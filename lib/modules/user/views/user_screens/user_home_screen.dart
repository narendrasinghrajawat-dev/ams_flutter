// lib/modules/user/views/user_screens/user_home_screen.dart
import 'dart:async';

import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/common/controller/loading_controller.dart';
import 'package:attedance_management_system/modules/user/controller/user_activity_controller.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/home/activity_tile.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/home/attendance_card.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/home/attendance_status_badge.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/home/empty_activity_state.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/home/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';

import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/modules/common/controller/common_controller.dart';

import '../../../common/services/device_information_service.dart';
import '../../../common/services/location_service.dart';
import '../../../common/services/storage_service.dart';
import '../../../models/attendance_activity.dart';
import '../../../models/masterData.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final UserActivityController _userActivityController =
  Get.find<UserActivityController>();

  final CommonController _commonController = Get.find<CommonController>();
  final StorageService _storageService = StorageService();

  Timer? _tick;
  Duration _elapsed = Duration.zero;
  bool _busy = false;

  // 🔹 Worker to react when attendanceActivities list changes (API success, punch, refresh)
  Worker? _activityWorker;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Initially try (in case activities already loaded)
    _initializeTimer();

    // 2️⃣ Whenever attendanceActivities changes, re-evaluate timer
    _activityWorker = ever<List<AttendanceActivity>>(
      _userActivityController.attendanceActivities,
          (_) {
        _initializeTimer();
      },
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    _activityWorker?.dispose();
    super.dispose();
  }

  void _initializeTimer() {
    // Always reset previous timer & elapsed when recalculating
    _stopTimer();

    final todayCheckIn = _getTodayCheckIn();
    final todayCheckOut = _getTodayCheckOut();

    if (todayCheckIn != null && todayCheckOut == null) {
      // ✅ Checked in, not checked out → start running timer
      final checkInTime = AppHelper.parseDateTime(todayCheckIn.punchDate);
      if (checkInTime != null) {
        _startTimer(checkInTime);
      } else {
        // parsing failed; reset
        setState(() {
          _elapsed = Duration.zero;
        });
      }
    } else if (todayCheckIn != null && todayCheckOut != null) {
      // ✅ Both exist → show final worked duration
      final duration = AppHelper.calculateDuration(
        todayCheckIn.punchDate,
        todayCheckOut.punchDate,
      );
      setState(() {
        _elapsed = duration ?? Duration.zero;
      });
    } else {
      // ❌ No check-in today → reset
      setState(() {
        _elapsed = Duration.zero;
      });
    }
  }


  void _startTimer(DateTime checkInTime) {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(checkInTime);
        });
      }
    });
  }

  void _stopTimer() {
    _tick?.cancel();
    _tick = null;
  }

  // Get today's check-in record
  AttendanceActivity? _getTodayCheckIn() {
    return _userActivityController.filteredAttendanceActivitiesList
        .firstWhereOrNull(
          (activity) =>
      AppHelper.isCheckIn(activity.punchType) &&
          AppHelper.isToday(activity.punchDate),
    );
  }

  // Get today's check-out record
  AttendanceActivity? _getTodayCheckOut() {
    return _userActivityController.filteredAttendanceActivitiesList
        .firstWhereOrNull(
          (activity) =>
      AppHelper.isCheckOut(activity.punchType) &&
          AppHelper.isToday(activity.punchDate),
    );
  }

  // Get today's activities filtered by date
  List<AttendanceActivity> _getTodayActivities() {
    return _userActivityController.filteredAttendanceActivitiesList
        .where((activity) => AppHelper.isToday(activity.punchDate))
        .toList();
  }

  // ------------ HELPERS FOR DEVICE & LOCATION VALIDATION ------------

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

  /// Builds an AttendanceActivity for punch with:
  /// - Current location
  /// - Office radius validation
  /// - Same-device validation
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
        "punchTime": nowLocal.toUtc().toIso8601String(), // UTC with Z
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

  // ---------------------- CHECK-IN / CHECK-OUT ----------------------

  void _onCheckIn() async {
    if (_busy) return;

    final todayCheckIn = _getTodayCheckIn();
    if (todayCheckIn != null) {
      final checkInTime = AppHelper.parseDateTime(todayCheckIn.punchDate);
      Get.snackbar(
        'Already Checked In',
        'You have already checked in today at ${AppHelper.formatTime(checkInTime)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    setState(() => _busy = true);

    // Build punch with location + office radius + device validation
    LoadingController().start();
    final activity = await _buildPunchActivity("1");
    LoadingController().hide();

    if (activity != null) {
      final success = await _userActivityController.punch(activity);

      if (success) {
        final checkInTime = AppHelper.parseDateTime(activity.punchDate);
        if (checkInTime != null) {
          _startTimer(checkInTime);
        }
      }
    }

    setState(() => _busy = false);
  }

  void _onCheckOut() async {
    if (_busy) return;

    final todayCheckIn = _getTodayCheckIn();
    if (todayCheckIn == null) {
      Get.snackbar(
        'Not Checked In',
        'Please check in first before checking out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    final todayCheckOut = _getTodayCheckOut();
    if (todayCheckOut != null) {
      final checkOutTime = AppHelper.parseDateTime(todayCheckOut.punchDate);
      Get.snackbar(
        'Already Checked Out',
        'You have already checked out today at ${AppHelper.formatTime(checkOutTime)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppThemeColors.warningColor.withOpacity(0.2),
      );
      return;
    }

    setState(() => _busy = true);

    // Build punch with location + office radius + device validation
    LoadingController().start();
    final activity = await _buildPunchActivity("2");
    LoadingController().hide();

    if (activity != null) {
      final success = await _userActivityController.punch(activity);

      if (success) {
        _stopTimer();

        final duration = AppHelper.calculateDuration(
          todayCheckIn.punchDate,
          activity.punchDate,
        );
        if (duration != null) {
          setState(() {
            _elapsed = duration;
          });
        }
      }
    }

    setState(() => _busy = false);
  }

  // ---------------------- STATS / UI HELPERS ----------------------

  Color _getStatusColor() {
    final todayCheckIn = _getTodayCheckIn();
    final todayCheckOut = _getTodayCheckOut();

    if (todayCheckIn == null) return AppThemeColors.muted;
    if (todayCheckOut != null) return AppThemeColors.successColor;
    return AppThemeColors.warningColor;
  }

  String _getStatusText() {
    final todayCheckIn = _getTodayCheckIn();
    final todayCheckOut = _getTodayCheckOut();

    if (todayCheckIn == null) return 'Not Started';
    if (todayCheckOut != null) return 'Completed';
    return 'Working';
  }

  double _calculateTotalHours() {
    double total = 0.0;
    final grouped = <String, List<AttendanceActivity>>{};

    for (var activity
    in _userActivityController.filteredAttendanceActivitiesList) {
      if (activity.punchDate != null) {
        final dateTime = AppHelper.parseDateTime(activity.punchDate);
        if (dateTime != null) {
          final dateKey = AppHelper.formatDate(dateTime);
          grouped.putIfAbsent(dateKey, () => []);
          grouped[dateKey]!.add(activity);
        }
      }
    }

    grouped.forEach((date, activities) {
      final checkIn =
      activities.firstWhereOrNull((a) => AppHelper.isCheckIn(a.punchType));
      final checkOut =
      activities.firstWhereOrNull((a) => AppHelper.isCheckOut(a.punchType));

      if (checkIn != null && checkOut != null) {
        final duration =
        AppHelper.calculateDuration(checkIn.punchDate, checkOut.punchDate);
        if (duration != null) {
          total += duration.inMinutes / 60.0;
        }
      }
    });

    return total;
  }

  int _getTotalDays() {
    return _userActivityController.filteredAttendanceActivitiesList
        .where((a) => AppHelper.isCheckIn(a.punchType))
        .map((a) {
      final dateTime = AppHelper.parseDateTime(a.punchDate);
      return dateTime != null ? AppHelper.formatDate(dateTime) : null;
    })
        .where((date) => date != null)
        .toSet()
        .length;
  }

  // ---------------------- BUILD UI ----------------------

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final todayCheckIn = _getTodayCheckIn();
      final todayCheckOut = _getTodayCheckOut();
      final todayActivities = _getTodayActivities();

      final totalDays = _getTotalDays();
      final totalHoursWorked = _calculateTotalHours();
      final averageHours =
      totalDays > 0 ? totalHoursWorked / totalDays : 0.0;

      final bool canCheckIn = todayCheckIn == null;
      final bool canCheckOut = todayCheckIn != null && todayCheckOut == null;
      final bool isCompleted = todayCheckIn != null && todayCheckOut != null;

      final checkInTime = AppHelper.parseDateTime(todayCheckIn?.punchDate);
      final checkOutTime = AppHelper.parseDateTime(todayCheckOut?.punchDate);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
          child: Column(
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget.large(
                        'Good ${AppHelper.getGreeting()}!',
                        color: AppThemeColors.textPrimaryColor,
                      ),
                      const SizedBox(height: 4),
                      AppTextWidget.small(
                        AppHelper.getProfileUser().middleName ?? 'User',
                        color: AppThemeColors.textSecondaryColor,
                      ),
                    ],
                  ),
                  AttendanceStatusBadge(
                    status: _getStatusText(),
                    color: _getStatusColor(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Timer & Buttons
              CommonCardWidget(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AppTextWidget.small(
                                'Today\'s Work Time',
                                color: AppThemeColors.textSecondaryColor,
                              ),
                              const SizedBox(height: 8),
                              if (!canCheckIn && !isCompleted) ...[
                                AppTextWidget.large(
                                  AppHelper.formatDuration(_elapsed),
                                  color: AppThemeColors.primaryColor,
                                ),
                                AppTextWidget.verySmall(
                                  'Running...',
                                  color: AppThemeColors.successColor,
                                ),
                              ] else if (isCompleted) ...[
                                AppTextWidget.large(
                                  AppHelper.formatDuration(_elapsed),
                                  color: AppThemeColors.textPrimaryColor,
                                ),
                                AppTextWidget.verySmall(
                                  'Completed',
                                  color: AppThemeColors.muted,
                                ),
                              ] else ...[
                                AppTextWidget.large(
                                  '00:00:00',
                                  color: AppThemeColors.textPrimaryColor,
                                ),
                                AppTextWidget.verySmall(
                                  'Not started',
                                  color: AppThemeColors.muted,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (canCheckIn) ...[
                              SizedBox(
                                height: 48,
                                width: 140,
                                child: ElevatedButton.icon(
                                  onPressed: _busy ? null : _onCheckIn,
                                  icon: const Icon(
                                    Icons.login_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: AppTextWidget.medium(
                                    'Check In',
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppThemeColors.successColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ] else if (canCheckOut) ...[
                              SizedBox(
                                height: 48,
                                width: 140,
                                child: ElevatedButton.icon(
                                  onPressed: _busy ? null : _onCheckOut,
                                  icon: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: AppTextWidget.medium(
                                    'Check Out',
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppThemeColors.errorColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                height: 48,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: AppThemeColors.muted
                                      .withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppThemeColors.borderColor,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: AppThemeColors.successColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      AppTextWidget.medium(
                                        'Completed',
                                        color: AppThemeColors
                                            .textSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Attendance Cards
              Row(
                children: [
                  Expanded(
                    child: AttendanceCard(
                      title: 'Check In',
                      time: AppHelper.formatTime(checkInTime),
                      subtitle: todayCheckIn != null
                          ? 'On Time'
                          : 'Not recorded',
                      icon: Icons.login_outlined,
                      color: AppThemeColors.successColor,
                      isRecorded: todayCheckIn != null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AttendanceCard(
                      title: 'Check Out',
                      time: AppHelper.formatTime(checkOutTime),
                      subtitle: todayCheckOut != null
                          ? 'Completed'
                          : 'Not recorded',
                      icon: Icons.logout_outlined,
                      color: AppThemeColors.errorColor,
                      isRecorded: todayCheckOut != null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Summary statistics row
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Total Days',
                      value: totalDays.toString(),
                      icon: Icons.calendar_today,
                      color: AppThemeColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'Avg Hours',
                      value: '${averageHours.toStringAsFixed(1)}h',
                      icon: Icons.access_time,
                      color: AppThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Activities list heading
              Row(
                children: [
                  AppTextWidget.medium(
                    'Today\'s Activity',
                    color: AppThemeColors.textPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppTextWidget.verySmall(
                      '${todayActivities.length}',
                      color: AppThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Activity list
              Expanded(
                child: todayActivities.isEmpty
                    ? const EmptyActivityState()
                    : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: todayActivities.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (ctx, idx) {
                    return ActivityTile(
                      activity: todayActivities[idx],
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
}
