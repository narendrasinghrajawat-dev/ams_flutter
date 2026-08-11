import 'dart:async';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_theme_colors.dart';
import '../../../../core/constants/const_strings.dart';
import '../../../../data/utils/app_helper.dart';
import '../../../../widgets/card/common_card.dart';
import '../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';

import '../../../common/controller/common_controller.dart';
import '../../../common/controller/loading_controller.dart';
import '../../../common/services/device_information_service.dart';
import '../../../common/services/location_service.dart';
import '../../../common/services/storage_service.dart';

import '../../../models/masterData.dart';
import '../../../models/attendance_activity.dart';

import '../../controller/user_activity_controller.dart';
import '../../helper/user_home_helper.dart';

import 'widgets/home/activity_tile.dart';
import 'widgets/home/attendance_status_badge.dart';
import 'widgets/home/empty_activity_state.dart';
import 'widgets/home/stats_card.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final CommonController _commonController = Get.find();
  final UserActivityController _activityCtrl = Get.find();
  final StorageService _storageService = StorageService();

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _busy = false;

  Worker? _worker;

  @override
  void initState() {
    super.initState();

    /// 🔁 Recalculate whenever attendance list changes
    _worker = ever<List<AttendanceActivity>>(
      _activityCtrl.activitiesByDate,
          (_) => _recalculateTimer(),
    );

    _recalculateTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _worker?.dispose();
    super.dispose();
  }

  // ===========================================================
  // ⏱️ SINGLE SOURCE OF TRUTH FOR TIMER
  // ===========================================================
  void _recalculateTimer() {
    _timer?.cancel();
    _timer = null;

    final activities = _activityCtrl.activitiesByDate;

    final checkIn = UserHomeHelper.todayCheckIn(activities);
    final checkOut = UserHomeHelper.todayCheckOut(activities);

    // ❌ No check-in → reset
    if (checkIn == null) {
      if (mounted) {
        setState(() => _elapsed = Duration.zero);
      }
      return;
    }

    final inTime = AppHelper.parseDateTime(checkIn.punchTime);
    if (inTime == null) {
      if (mounted) {
        setState(() => _elapsed = Duration.zero);
      }
      return;
    }

    // ✅ Checked out → STOP timer & set final duration
    if (checkOut != null) {
      if (mounted) {
        setState(() {
          _elapsed = UserHomeHelper.elapsedToday(checkIn, checkOut);
        });
      }
      return;
    }

    // ✅ Checked in only → SHOW elapsed immediately (🔥 FIX)
    if (mounted) {
      setState(() {
        _elapsed = DateTime.now().difference(inTime);
      });
    }

    // ✅ Live timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final latestCheckOut =
      UserHomeHelper.todayCheckOut(_activityCtrl.activitiesByDate);

      if (latestCheckOut != null || !mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _elapsed = DateTime.now().difference(inTime);
      });
    });
  }

  // ===========================================================
  // 📍 BUILD PUNCH DATA
  // ===========================================================
  Future<AttendanceActivity?> _buildPunchActivity(String punchType) async {
    try {
      final locRes = await LocationService.instance.getCurrentLocation();
      final userLat = locRes.position?.latitude ?? 26.9124;
      final userLng = locRes.position?.longitude ?? 75.7873;

      final masterData = _commonController.masterData.value ?? _commonController.getMasterData.value;
      final officeLat = double.tryParse(masterData?.officeLat ?? '') ?? 26.9124;
      final officeLng = double.tryParse(masterData?.officeLong ?? '') ?? 75.7873;
      final officeRadius = masterData?.officeRadius?.toDouble() ?? 100.0;

      final isWFH = _activityCtrl.isWorkFromHome.value;

      if (!isWFH) {
        final isInside = LocationService.instance.isWithinRadius(
          userLat: userLat,
          userLng: userLng,
          targetLat: officeLat,
          targetLng: officeLng,
          radiusInMeters: officeRadius,
        );

        if (!isInside) {
          _activityCtrl.isWorkFromHome.value = true;
          UIHelper.showSnackbar(
            "WFH Enabled",
            'Outside office radius (100m). Punched as Work From Home.',
            type: SnackbarType.info,
            duration: const Duration(seconds: 4),
          );
        }
      }

      final currentDevice = await DeviceService.getDeviceInformation();
      var storedDevice = _storageService.readMap(AppStrings.deviceInformation);

      if (storedDevice == null) {
        _storageService.saveMap(AppStrings.deviceInformation, currentDevice);
        storedDevice = currentDevice;
      } else if (!_isSameDevice(currentDevice, storedDevice)) {
        UIHelper.showSnackbar("Device Mismatch", 'Attendance allowed only from your login device', type: SnackbarType.error);
        return null;
      }

      final user = AppHelper.getProfileUser();
      final userKey = (user.key != null && user.key!.isNotEmpty)
          ? user.key!
          : (user.id != null && user.id!.isNotEmpty ? user.id! : "");

      if (userKey.isEmpty) {
        UIHelper.showSnackbar("Session Expired", 'Please log in again to record attendance.', type: SnackbarType.error);
        return null;
      }

      final now = DateTime.now();

      return AttendanceActivity.fromJson({
        "userKey": userKey,
        "punchType": punchType,
        "punchTime": now.toIso8601String(),
        "punchDate": now.toIso8601String(),
        "lat": locRes.position?.latitude.toString() ?? "0.0",
        "long": locRes.position?.longitude.toString() ?? "0.0",
        "deviceInformation": currentDevice,
        "isWFH" : _activityCtrl.isWorkFromHome.value,
      });
    } catch (e) {
      print('Punch activity build error: $e');
      UIHelper.showSnackbar("Error", 'Failed to initialize punch activity: $e', type: SnackbarType.error);
      return null;
    }
  }

  bool _isSameDevice(
      Map<String, dynamic> current,
      Map<String, dynamic> stored,
      ) {
    if (kIsWeb) {
      return current['os']?.toString() == stored['os']?.toString();
    }
    final currentId = current['androidId'] ?? current['uniqueId'];
    final storedId = stored['androidId'] ?? stored['uniqueId'];
    if (currentId != null && storedId != null && currentId.toString().isNotEmpty) {
      return currentId.toString() == storedId.toString();
    }
    return true;
  }

  // ===========================================================
  // ▶️ CHECK IN / CHECK OUT
  // ===========================================================
  Future<void> _onCheckIn() async {
    if (_busy) return;

    final activities = _activityCtrl.activitiesByDate;
    if (UserHomeHelper.todayCheckIn(activities) != null) return;

    setState(() => _busy = true);
    final loading = Get.isRegistered<LoadingController>() ? Get.find<LoadingController>() : null;
    loading?.start();

    if (_activityCtrl.isWorkFromHome.value == true) {
      _activityCtrl.totalTakenWFH.value++;
    }

    try {
      final activity = await _buildPunchActivity("1");
      if (activity != null) {
        await _activityCtrl.punch(activity);
      }
    } catch (e) {
      print('CheckIn error: $e');
    } finally {
      loading?.hide();
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _onCheckOut() async {
    if (_busy) return;

    final activities = _activityCtrl.activitiesByDate;
    if (UserHomeHelper.todayCheckOut(activities) != null) return;

    setState(() => _busy = true);
    final loading = Get.isRegistered<LoadingController>() ? Get.find<LoadingController>() : null;
    loading?.start();

    try {
      final activity = await _buildPunchActivity("2");
      if (activity != null) {
        await _activityCtrl.punch(activity);
      }
    } catch (e) {
      print('CheckOut error: $e');
    } finally {
      loading?.hide();
      if (mounted) setState(() => _busy = false);
    }
  }

  // ===========================================================
  // 🖥️ UI
  // ===========================================================
  @override
  Widget build(BuildContext context) {
    print('_elapsed is the $_elapsed');

    return Obx(() {
      final activities = _activityCtrl.activitiesByDate;

      final checkIn = UserHomeHelper.todayCheckIn(activities);
      final checkOut = UserHomeHelper.todayCheckOut(activities);

      final canCheckIn = checkIn == null;
      final canCheckOut = checkIn != null && checkOut == null;
      final completed = checkIn != null && checkOut != null;

      final todayHours = UserHomeHelper.totalHoursToday(activities);
      final recent = UserHomeHelper.recentActivities(activities, limit: 8);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 kIsWeb ? AppTextWidget.large('good_${AppHelper.getGreeting().toLowerCase()}') : AppTextWidget.medium('good_${AppHelper.getGreeting().toLowerCase()}'),
                  Row(
                    children: [

                      /// 🔹 WFH Radio
                      Obx(() {
                        final master = _commonController.getMasterData.value;
                        final maxWFH = master?.maxWFHInSingleMonth;

                        if (maxWFH != null && _activityCtrl.totalTakenWFH.value >= maxWFH || _elapsed != Duration.zero) {
                          return const SizedBox();
                        }

                        return Row(
                          children: [
                            AppTextWidget.medium("WFH"),
                            const SizedBox(width: 8),
                            Switch(
                              padding: EdgeInsets.all(0),
                              splashRadius: 1,
                              value: _activityCtrl.isWorkFromHome.value,
                              activeColor: Colors.white,
                              activeTrackColor: AppThemeColors.primaryColor,
                              inactiveTrackColor: AppThemeColors.buttonDisabledColor,
                              onChanged: canCheckIn == false && _activityCtrl.isWorkFromHome.value == true
                                  ? null
                                  : (value) {
                                _activityCtrl.isWorkFromHome.value = value;
                              },
                            ),
                          ],
                        );
                      }),

                      SizedBox(width: 5,),

                      AttendanceStatusBadge(
                        status: completed
                            ? 'Completed'
                            : canCheckIn
                            ? 'Not Started'
                            : 'Working',
                        color: completed
                            ? AppThemeColors.successColor
                            : canCheckIn
                            ? AppThemeColors.muted
                            : AppThemeColors.warningColor,
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 14),

              CommonCardWidget(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget.small("today_work_time"),
                          const SizedBox(height: 6),
                          AppTextWidget.large(
                            AppHelper.formatDuration(_elapsed),
                            color: AppThemeColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    if (canCheckIn)
                      _actionBtn(
                        'check_in',
                        Icons.login_rounded,
                        AppThemeColors.primaryColor,
                        _onCheckIn,
                      )
                    else if (canCheckOut)
                      _actionBtn(
                        'check_out',
                        Icons.logout_rounded,
                        AppThemeColors.errorColor,
                        _onCheckOut,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              StatsCard(
                title: 'today_hours',
                value: '${todayHours.toStringAsFixed(1)}h',
                icon: Icons.access_time,
                color: AppThemeColors.primaryColor,
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.medium('recent_activities'),
                  AppTextWidget.verySmall(
                    'Last ${recent.length}',
                    color: AppThemeColors.muted,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: recent.isEmpty
                    ? const EmptyActivityState()
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWideScreen = constraints.maxWidth >= 700;

                    // 📱 Mobile → Single column list
                    if (!isWideScreen) {
                      return ListView.separated(
                        itemCount: recent.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            UserActivityTile(activity: recent[i]),
                      );
                    }

                    // 🌐 Web / Desktop → 2 items per row
                    return GridView.builder(
                      itemCount: recent.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,          // 👈 2 tiles per row
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isWideScreen ? 9 : 3.5,      // 👈 adjust for tile height
                      ),
                      itemBuilder: (_, i) =>
                          UserActivityTile(activity: recent[i]),
                    );
                  },
                ),
              ),


            ],
          ),
        ),
      );
    });
  }

  Widget _actionBtn(
      String label,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return SizedBox(
      height: 44,
      width: 150,
      child: ElevatedButton.icon(
        onPressed: _busy ? null : onTap,
        icon: AppIconWidget.medium(icon, color: Colors.white),
        label: AppTextWidget.medium(label, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
