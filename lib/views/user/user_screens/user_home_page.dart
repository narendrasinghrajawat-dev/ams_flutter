// lib/views/user/user_home_page.dart
import 'dart:async';
import 'package:attedance_management_system/controller/user_controller.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../models/attendance_activity.dart';
import '../../../widgets/card/common_card.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';
import 'homepage_widgets/user_homepage_widgets.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final UserController _userController = Get.find<UserController>();

  Timer? _tick;
  Duration _elapsed = Duration.zero;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    final todayCheckIn = _getTodayCheckIn();
    final todayCheckOut = _getTodayCheckOut();

    if (todayCheckIn != null && todayCheckOut == null) {
      final checkInTime = AppHelper.parseDateTime(todayCheckIn.punchDate);
      if (checkInTime != null) {
        _startTimer(checkInTime);
      }
    } else if (todayCheckIn != null && todayCheckOut != null) {
      final duration = AppHelper.calculateDuration(
        todayCheckIn.punchDate,
        todayCheckOut.punchDate,
      );
      if (duration != null) {
        _elapsed = duration;
      }
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
  }

  // Get today's check-in record
  AttendanceActivity? _getTodayCheckIn() {
    return _userController.attendanceActivitiesList.firstWhereOrNull(
          (activity) =>
      AppHelper.isCheckIn(activity.punchType) &&
          AppHelper.isToday(activity.punchDate),
    );
  }

  // Get today's check-out record
  AttendanceActivity? _getTodayCheckOut() {
    return _userController.attendanceActivitiesList.firstWhereOrNull(
          (activity) =>
      AppHelper.isCheckOut(activity.punchType) &&
          AppHelper.isToday(activity.punchDate),
    );
  }

  // Get today's activities filtered by date
  List<AttendanceActivity> _getTodayActivities() {
    return _userController.attendanceActivitiesList
        .where((activity) => AppHelper.isToday(activity.punchDate))
        .toList();
  }

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

    var json = {
      "userKey": AppHelper.getProfileUser().key,
      "punchType": "1",
      "punchTime": TimeOfDay.now().toString(),
      "punchDate": DateTime.now().toIso8601String(),
      "lat": "25",
      "long": "78",
      "deviceInformation": {
        "os": "Android",
        "version": "12",
        "sdkInt": 31,
        "model": "2201117PI",
        "brand": "Oppo",
        "device": "miel"
      }
    };

    final success = await _userController.punchIn(AttendanceActivity.fromJson(json));

    if (success) {
      final checkIn = _getTodayCheckIn();
      if (checkIn != null) {
        final checkInTime = AppHelper.parseDateTime(checkIn.punchDate);
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

    var json = {
      "userKey": AppHelper.getProfileUser().key,
      "punchType": "2",
      "punchTime": TimeOfDay.now().toString(),
      "punchDate": DateTime.now().toIso8601String(),
      "lat": "25",
      "long": "78",
      "deviceInformation": {
        "os": "Android",
        "version": "12",
        "sdkInt": 31,
        "model": "2201117PI",
        "brand": "Oppo",
        "device": "miel"
      }
    };

    final success = await _userController.punchOut(AttendanceActivity.fromJson(json));

    if (success) {
      _stopTimer();
      final checkOut = _getTodayCheckOut();
      if (checkOut != null) {
        final duration = AppHelper.calculateDuration(
          todayCheckIn.punchDate,
          checkOut.punchDate,
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

    for (var activity in _userController.attendanceActivitiesList) {
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
      final checkIn = activities.firstWhereOrNull((a) => AppHelper.isCheckIn(a.punchType));
      final checkOut = activities.firstWhereOrNull((a) => AppHelper.isCheckOut(a.punchType));

      if (checkIn != null && checkOut != null) {
        final duration = AppHelper.calculateDuration(checkIn.punchDate, checkOut.punchDate);
        if (duration != null) {
          total += duration.inMinutes / 60.0;
        }
      }
    });

    return total;
  }

  int _getTotalDays() {
    return _userController.attendanceActivitiesList
        .where((a) => AppHelper.isCheckIn(a.punchType))
        .map((a) {
      final dateTime = AppHelper.parseDateTime(a.punchDate);
      return dateTime != null ? AppHelper.formatDate(dateTime) : null;
    })
        .where((date) => date != null)
        .toSet()
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final todayCheckIn = _getTodayCheckIn();
      final todayCheckOut = _getTodayCheckOut();
      final todayActivities = _getTodayActivities();

      final totalDays = _getTotalDays();
      final totalHoursWorked = _calculateTotalHours();
      final averageHours = totalDays > 0 ? totalHoursWorked / totalDays : 0.0;

      final bool canCheckIn = todayCheckIn == null;
      final bool canCheckOut = todayCheckIn != null && todayCheckOut == null;
      final bool isCompleted = todayCheckIn != null && todayCheckOut != null;

      final checkInTime = AppHelper.parseDateTime(todayCheckIn?.punchDate);
      final checkOutTime = AppHelper.parseDateTime(todayCheckOut?.punchDate);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                                  label: AppTextWidget.medium('Check In', color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemeColors.successColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                                  label: AppTextWidget.medium('Check Out', color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemeColors.errorColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                  color: AppThemeColors.muted.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppThemeColors.borderColor),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: AppThemeColors.successColor, size: 20),
                                      const SizedBox(width: 6),
                                      AppTextWidget.medium(
                                        'Completed',
                                        color: AppThemeColors.textSecondaryColor,
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
                      subtitle: todayCheckIn != null ? 'On Time' : 'Not recorded',
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
                      subtitle: todayCheckOut != null ? 'Completed' : 'Not recorded',
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, idx) {
                    return ActivityTile(activity: todayActivities[idx]);
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