// lib/modules/user/views/user_screens/user_home_screen.dart
import 'dart:async';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../../core/constants/const_strings.dart';
import '../../../../data/utils/app_helper.dart';
import '../../../../widgets/card/common_card.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../common/controller/common_controller.dart';
import '../../../common/controller/loading_controller.dart';
import '../../../common/services/device_information_service.dart';
import '../../../common/services/location_service.dart';
import '../../../common/services/storage_service.dart';
import '../../../models/masterData.dart';
import '../../helper/user_home_helper.dart';
import '../../controller/user_activity_controller.dart';
import '../../views/user_screens/widgets/home/activity_tile.dart';
import '../../views/user_screens/widgets/home/attendance_status_badge.dart';
import '../../views/user_screens/widgets/home/empty_activity_state.dart';
import '../../views/user_screens/widgets/home/stats_card.dart';
import '../../../models/attendance_activity.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {


  final CommonController _commonController = Get.find<CommonController>();
  final UserActivityController _activityCtrl = Get.find<UserActivityController>();
  final StorageService _storageService = StorageService();

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _busy = false;

  Worker? _worker;

  @override
  void initState() {
    super.initState();

    _recalculateTimer();

    // _worker = ever<List<AttendanceActivity>>(
    //   _activityCtrl.attendanceActivities,
    //       (_) => _recalculateTimer(),
    // );
  }


  Future<AttendanceActivity?> _buildPunchActivity(String punchType) async {
    try {
      // 1️⃣ Get current location
      final locRes = await LocationService.instance.getCurrentLocation();

      if (!locRes.ok || locRes.position == null) {
        Get.snackbar(
          'Location',
          locRes.message ?? 'Unable to get current location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
        );
        return null;
      }

      final double userLat = locRes.position!.latitude;
      final double userLng = locRes.position!.longitude;

      // 2️⃣ Master data & office radius
      final MasterData? masterData = _commonController.masterData.value;

      if (masterData == null) {
        Get.snackbar(
          'Master Data',
          'Master data not loaded. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
        );
        return null;
      }

      final officeLat = double.tryParse(masterData.officeLat ?? '');
      final officeLng = double.tryParse(masterData.officeLong ?? '');

      // If officeRadius is int/double in your model:
      final double? officeRadius = masterData.officeRadius?.toDouble();

      if (officeLat == null || officeLng == null) {
        Get.snackbar(
          'Office Location',
          'Office coordinates are not configured properly.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
        );
        return null;
      }

      final isInsideOfficeRadius = LocationService.instance.isWithinRadius(
        userLat: userLat,
        userLng: userLng,
        targetLat: officeLat,
        targetLng: officeLng,
        radiusInMeters: officeRadius ?? 100.0,
      );

      // 👉 Uncomment to enforce office geo-fence
      if (!isInsideOfficeRadius) {
        Get.snackbar(
          'Outside Office Area',
          'You must be within ${officeRadius ?? 100} meters of the office to punch.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
        );
        return null;
      }

      // 3️⃣ Device validation: must be same as login device
      final Map<String, dynamic> currentDeviceMap =
      await DeviceService.getDeviceInformation();

      final Map<String, dynamic>? storedDeviceMap = _storageService.readMap(AppStrings.deviceInformation);

      if (storedDeviceMap == null || storedDeviceMap.isEmpty) {
        Get.snackbar(
          'Device Verification',
          'Device info not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
        );
        return null;
      }

      if (!_isSameDevice(currentDeviceMap, storedDeviceMap)) {
        Get.snackbar(
          'Device Mismatch',
          'Attendance can be marked only from the device used for login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
        );
        return null;
      }

      // 4️⃣ Build punch JSON (same format as DB)
      final nowLocal = DateTime.now();
      final punchJson = {
        "userKey": AppHelper.getProfileUser().key,
        "punchType": punchType, // "1" = check-in, "2" = check-out
        "punchTime": nowLocal.toIso8601String(), // UTC with Z
        "punchDate": nowLocal.toIso8601String(), // local
        "lat": userLat.toString(),
        "long": userLng.toString(),
        "deviceInformation": currentDeviceMap,
      };
      return AttendanceActivity.fromJson(punchJson);
    } catch (e) {
      print('Punch build error: $e');
      Get.snackbar(
        'Error',
        'Failed to prepare punch data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.errorColor.withOpacity(0.1),
      );
      return null;
    }
  }


  bool _isSameDevice(
      Map<String, dynamic> current,
      Map<String, dynamic> stored,
      ) {
    const keys = [
      'os',
      'version',
      'sdkInt',
      'model',
      'brand',
      'androidId',
      'fingerprint',
      'uniqueId',
    ];
    for (final key in keys) {
      final currentVal = current[key]?.toString();
      final storedVal = stored[key]?.toString();
      if (currentVal != storedVal) {
        return false;
      }
    }
    return true;
  }


  void _onCheckIn() async {
    if (_busy) return;

    final activities = _activityCtrl.activitiesByDate;
    final todayCheckIn = UserHomeHelper.todayCheckIn(activities);

    if (todayCheckIn != null) {
      final time =
      AppHelper.formatTime(AppHelper.parseDateTime(todayCheckIn.punchTime));
      Get.snackbar(
        'Already Checked In',
        'You checked in at $time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    setState(() => _busy = true);

    LoadingController().start();

    final AttendanceActivity? activity = await _buildPunchActivity("1"); // 1 = check-in

    LoadingController().hide();

    if (activity != null) {
      final success = await _activityCtrl.punch(activity);

      if (success) {
        final inTime = AppHelper.parseDateTime(activity.punchTime);
        if (inTime != null) {
          _startLiveTimer(inTime);
        }
      }
    }

    setState(() => _busy = false);
  }

  void _onCheckOut() async {
    if (_busy) return;

    final activities = _activityCtrl.activitiesByDate;
    final todayCheckIn = UserHomeHelper.todayCheckIn(activities);
    final todayCheckOut = UserHomeHelper.todayCheckOut(activities);

    if (todayCheckIn == null) {
      Get.snackbar(
        'Not Checked In',
        'Please check in first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    if (todayCheckOut != null) {
      final time =
      AppHelper.formatTime(AppHelper.parseDateTime(todayCheckOut.punchTime));
      Get.snackbar(
        'Already Checked Out',
        'You checked out at $time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    setState(() => _busy = true);

    LoadingController().start();

    final AttendanceActivity? activity =
    await _buildPunchActivity("2"); // 2 = check-out

    LoadingController().hide();

    if (activity != null) {
      final success = await _activityCtrl.punch(activity);

      if (success) {
        _stopLiveTimer();

        final duration = UserHomeHelper.elapsedToday(
          todayCheckIn,
          activity,
        );

        setState(() {
          _elapsed = duration;
        });
      }
    }

    setState(() => _busy = false);
  }

  void _startLiveTimer(DateTime checkInTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(checkInTime);
        });
      }
    });
  }

  void _stopLiveTimer() {
    _timer?.cancel();
    _timer = null;
  }



  @override
  void dispose() {
    _timer?.cancel();
    _worker?.dispose();
    super.dispose();
  }

  void _recalculateTimer() {
    _timer?.cancel();

    final activities = _activityCtrl.activitiesByDate;

    final checkIn = UserHomeHelper.todayCheckIn(activities);
    final checkOut = UserHomeHelper.todayCheckOut(activities);

    if (checkIn == null) {
      setState(() => _elapsed = Duration.zero);
      return;
    }

    final inTime = AppHelper.parseDateTime(checkIn.punchTime);
    if (inTime == null) {
      setState(() => _elapsed = Duration.zero);
      return;
    }

    if (checkOut == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _elapsed = DateTime.now().difference(inTime);
          });
        }
      });
    } else {
      setState(() {
        _elapsed = UserHomeHelper.elapsedToday(checkIn, checkOut);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activities = _activityCtrl.activitiesByDate;

      final checkIn = UserHomeHelper.todayCheckIn(activities);
      final checkOut = UserHomeHelper.todayCheckOut(activities);

      final todayHours = UserHomeHelper.totalHoursToday(activities);


      final canCheckIn = checkIn == null;
      final canCheckOut = checkIn != null && checkOut == null;
      final completed = checkIn != null && checkOut != null;
      final recentActivities = UserHomeHelper.recentActivities(activities, limit: 8);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.large(
                    'Good ${AppHelper.getGreeting()}!',
                  ),
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

              const SizedBox(height: 14),

              /// TIMER CARD
              CommonCardWidget(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget.small('Today\'s Work Time'),
                          const SizedBox(height: 8),
                          AppTextWidget.large(
                            AppHelper.formatDuration(_elapsed),
                            color: completed
                                ? AppThemeColors.textPrimaryColor
                                : AppThemeColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    if (canCheckIn)
                      _actionBtn(
                        'Check In',
                        Icons.login_rounded,
                        AppThemeColors.successColor,
                        _onCheckIn,
                      )
                    else if (canCheckOut)
                      _actionBtn(
                        'Check Out',
                        Icons.logout_rounded,
                        AppThemeColors.errorColor,
                        _onCheckOut,
                      )

                  ],
                ),
              ),

              const SizedBox(height: 14),

              /// STATS
              Row(
                children: [
                  // Expanded(
                  //   child: StatsCard(
                  //     title: 'Today Hours',
                  //     value: '${todayHours.toStringAsFixed(1)}h',
                  //     icon: Icons.access_time,
                  //     color: AppThemeColors.primaryColor,
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'Today Hours',
                      value: '${todayHours.toStringAsFixed(1)}h',
                      icon: Icons.access_time,
                      color: AppThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),


              /// 🔹 RECENT ACTIVITIES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.medium('Recent Activities'),
                  AppTextWidget.verySmall(
                    'Last ${recentActivities.length}',
                    color: AppThemeColors.muted,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: recentActivities.isEmpty
                    ? const EmptyActivityState()
                    : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: recentActivities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => UserActivityTile(
                    activity: recentActivities[i],
                  ),
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
        icon: AppIconWidget.medium(icon, color: AppThemeColors.whiteColor ),
        label: AppTextWidget.medium(label,color: AppThemeColors.whiteColor ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
