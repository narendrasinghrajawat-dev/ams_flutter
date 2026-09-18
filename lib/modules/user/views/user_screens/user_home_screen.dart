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
import '../../../common/controller/settings_controller.dart';
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
  final SettingsController _settings = Get.find();
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

    // No check-in → reset
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

    // Checked out → STOP timer & set final duration
    if (checkOut != null) {
      if (mounted) {
        setState(() {
          _elapsed = UserHomeHelper.elapsedToday(checkIn, checkOut);
        });
      }
      return;
    }

    // Checked in only → SHOW elapsed immediately
    if (mounted) {
      setState(() {
        _elapsed = DateTime.now().difference(inTime);
      });
    }

    // Live timer
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
          UIHelper.showSnackbar(
            "Outside Office Radius",
            'You are outside the office radius (100m). Please enable the "WFH" toggle at the top to punch in.',
            type: SnackbarType.warning,
            duration: const Duration(seconds: 5),
          );
          return null;
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
    return Obx(() {
      final isDark = _settings.isDark.value;
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              // Top Bar: Greeting & WFH switch & Status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.medium(
                    'good_${AppHelper.getGreeting().toLowerCase()}',
                    color: AppThemeColors.textPrimaryColor,
                  ),
                  Row(
                    children: [
                      // WFH Toggle
                      Obx(() {
                        final master = _commonController.getMasterData.value;
                        final maxWFH = master?.maxWFHInSingleMonth;

                        if (maxWFH != null && _activityCtrl.totalTakenWFH.value >= maxWFH || _elapsed != Duration.zero) {
                          return const SizedBox();
                        }

                        return Row(
                          children: [
                            AppTextWidget.small("WFH", color: AppThemeColors.textSecondaryColor),
                            const SizedBox(width: 4),
                            Switch.adaptive(
                              value: _activityCtrl.isWorkFromHome.value,
                              activeColor: AppThemeColors.primaryColor,
                              onChanged: canCheckIn == false && _activityCtrl.isWorkFromHome.value == true
                                  ? null
                                  : (value) {
                                      _activityCtrl.isWorkFromHome.value = value;
                                    },
                            ),
                          ],
                        );
                      }),

                      const SizedBox(width: 6),

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
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Today's Work Time Card with live timer and Action Button
              CommonCardWidget(
                padding: 16,
                borderRadius: 16,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppThemeColors.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.timer_outlined,
                        color: AppThemeColors.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget.verySmall(
                            "today_work_time",
                            color: AppThemeColors.textSecondaryColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppHelper.formatDuration(_elapsed),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.primaryColor,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
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

              const SizedBox(height: 12),

              StatsCard(
                title: 'today_hours',
                value: '${todayHours.toStringAsFixed(1)}h',
                icon: Icons.access_time_rounded,
                color: AppThemeColors.secondaryColor,
              ),

              const SizedBox(height: 16),

              // Recent activities header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.medium(
                    'recent_activities',
                    color: AppThemeColors.textPrimaryColor,
                  ),
                  AppTextWidget.verySmall(
                    'Last ${recent.length}',
                    color: AppThemeColors.muted,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Activities List
              Expanded(
                child: recent.isEmpty
                    ? const EmptyActivityState()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isWideScreen = constraints.maxWidth >= 700;

                          if (!isWideScreen) {
                            return ListView.separated(
                              itemCount: recent.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) =>
                                  UserActivityTile(activity: recent[i]),
                            );
                          }

                          return GridView.builder(
                            itemCount: recent.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 10,
                              childAspectRatio: isWideScreen ? 7.5 : 3.5,
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
      height: 42,
      child: ElevatedButton.icon(
        onPressed: _busy ? null : onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: AppTextWidget.medium(label, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
