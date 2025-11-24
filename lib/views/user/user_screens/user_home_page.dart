// lib/views/user/user_home_page.dart
import 'dart:async';
import 'package:attedance_management_system/controller/user_controller.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/models/punch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';
import '../../../widgets/card/common_card.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  final UserController _userController = Get.find<UserController>();

  // sample static values (totalDays, breakTime remain static for now)
  final String totalDays = '28';

  // Activity list (most recent first)
  final List<Map<String, dynamic>> _activity = [];

  // Check-in / check-out state
  DateTime? _checkInAt;
  DateTime? _checkOutAt;
  Timer? _tick;
  Duration _elapsed = Duration.zero;

  // UI loading state when tapping
  bool _busy = false;

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_checkInAt != null) {
        setState(() {
          _elapsed = DateTime.now().difference(_checkInAt!);
        });
      }
    });
  }

  void _stopTimer() {
    _tick?.cancel();
  }

  String _formatDuration(Duration d) {
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hh:$mm:$ss";
  }

  void _onCheckIn() async {

    var json = {
      "userKey" : AppHelper.getProfileUser().key,
      "punchType" : "1",
      "punchTime" : TimeOfDay.now().toString(),
      "punchDate" : DateTime.now().toIso8601String(),
      "lat" : "25",
      "long" : "78",
      "deviceInformation": {
        "os": "Android",
        "version": "12",
        "sdkInt": 31,
        "model": "2201117PI",
        "brand": "Oppo",
        "device": "miel"
      }
    };


   final res = _userController.punchIn(Punch.fromJson(json));

    if (_busy) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 300)); // simulate small delay
    final now = DateTime.now();
    setState(() {
      _checkInAt = now;
      _checkOutAt = null;
      _elapsed = Duration.zero;
      _activity.insert(0, {
        'type': 'Check In',
        'time': _timeLabel(now),
        'date': _dateLabel(now),
        'status': 'On Time'
      });
    });
    _startTimer();
    Get.snackbar('Checked in', 'You checked in at ${_timeLabel(now)}', snackPosition: SnackPosition.BOTTOM);
    setState(() => _busy = false);
  }

  void _onCheckOut() async {

    var json = {
      "userKey" : AppHelper.getProfileUser().key,
      "punchType" : "2",
      "punchTime" : TimeOfDay.now().toString(),
      "punchDate" : DateTime.now().toIso8601String(),
      "lat" : "25",
      "long" : "78",
      "deviceInformation": {
        "os": "Android",
        "version": "12",
        "sdkInt": 31,
        "model": "2201117PI",
        "brand": "Oppo",
        "device": "miel"
      }
    };

    final res = _userController.punchOut(Punch.fromJson(json));

    if (_busy || _checkInAt == null) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 300)); // small delay
    final now = DateTime.now();
    setState(() {
      _checkOutAt = now;
      _elapsed = now.difference(_checkInAt!);
      _activity.insert(0, {
        'type': 'Check Out',
        'time': _timeLabel(now),
        'date': _dateLabel(now),
        'status': 'Go Home'
      });
    });
    _stopTimer();
    Get.snackbar('Checked out', 'You checked out at ${_timeLabel(now)}', snackPosition: SnackPosition.BOTTOM);
    setState(() => _busy = false);
  }

  String _timeLabel(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $ampm';
  }

  String _dateLabel(DateTime dt) {
    return '${_month(dt.month)} ${dt.day}, ${dt.year}';
  }

  String _month(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[(m-1).clamp(0,11)];
  }

  @override
  Widget build(BuildContext context) {

    // Use top area to show timer and buttons
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            // --- Timer & Buttons area ---
            CommonCardWidget(
              child: Row(
                children: [
                  // Left: status + elapsed/time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget.small('Today', color: AppThemeColors.textSecondaryColor),
                        const SizedBox(height: 6),
                        if (_checkInAt == null) ...[
                          AppTextWidget.large('Not checked in', color: AppThemeColors.textPrimaryColor),
                        ] else if (_checkOutAt == null) ...[
                          AppTextWidget.large(_formatDuration(_elapsed), color: AppThemeColors.primaryColor),
                        ] else ...[
                          AppTextWidget.large('${_timeLabel(_checkInAt!)} → ${_timeLabel(_checkOutAt!)}', color: AppThemeColors.textPrimaryColor),
                        ],
                      ],
                    ),
                  ),

                  // Right: buttons
                  Column(
                    children: [
                      if (_checkInAt == null) ...[
                        SizedBox(
                          height: 46,
                          width: 146,
                          child: ElevatedButton.icon(
                            onPressed: _busy ? null : _onCheckIn,
                            icon: const Icon(Icons.login_rounded,  color: Colors.white),
                            label: AppTextWidget.medium('Check In', color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemeColors.successColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ] else if (_checkOutAt == null) ...[
                        SizedBox(
                          height: 46,
                          width: 146,
                          child: ElevatedButton.icon(
                            onPressed: _busy ? null : _onCheckOut,
                            icon: const Icon(Icons.logout_rounded),
                            label: AppTextWidget.medium('Check Out', color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemeColors.errorColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          height: 46,
                          width: 146,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // allow re-check-in for demo (resets)
                              setState(() {
                                _checkInAt = null;
                                _checkOutAt = null;
                                _elapsed = Duration.zero;
                              });
                              Get.snackbar('Reset', 'Check-in status reset', snackPosition: SnackPosition.BOTTOM);
                            },
                            icon: const Icon(Icons.refresh),
                            label: AppTextWidget.medium('Reset', color: AppThemeColors.primaryColor),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppThemeColors.primaryColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // --- Today Attendance cards (two cards shown) ---
            Row(
              children: [
                Expanded(
                  child: _AttendanceCard(
                    title: 'Check In',
                    time: _checkInAt != null ? _timeLabel(_checkInAt!) : '--:--',
                    subtitle: _checkInAt != null ? 'Recorded' : 'Not recorded',
                    icon: Icons.login_outlined,
                    color: AppThemeColors.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AttendanceCard(
                    title: 'Check Out',
                    time: _checkOutAt != null ? _timeLabel(_checkOutAt!) : '--:--',
                    subtitle: _checkOutAt != null ? 'Recorded' : 'Not recorded',
                    icon: Icons.logout_outlined,
                    color: AppThemeColors.errorColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Summary row (Break and Total Days)
            Row(
              children: [

                Expanded(
                  child: _AttendanceSmallCard(
                    title: 'Total Days',
                    value: totalDays,
                    icon: Icons.calendar_today,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Activities list heading
            Row(
              children: [
                AppTextWidget.medium('Your Activity', color: AppThemeColors.textPrimaryColor),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: AppTextWidget.small('View All', color: AppThemeColors.primaryColor),
                )
              ],
            ),

            const SizedBox(height: 8),

            // Activity list
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _activity.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, idx) {
                  final item = _activity[idx];
                  return _buildActivityTile(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> item) {
    final String type = (item['type'] ?? '').toString();
    final bool isCheckIn = type.toLowerCase().contains('check in') || type.toLowerCase().contains('checkin');
    final bool isCheckOut = type.toLowerCase().contains('check out') || type.toLowerCase().contains('checkout');

    final Color bgColor = isCheckIn ? AppThemeColors.successColor : (isCheckOut ? AppThemeColors.errorColor : AppThemeColors.primaryLightColor.withOpacity(0.12));
    final Color iconColor = isCheckIn ? AppThemeColors.successColor : (isCheckOut ? AppThemeColors.errorColor : AppThemeColors.primaryColor);
    final IconData icon = isCheckIn ? Icons.login_rounded : (isCheckOut ? Icons.logout_rounded : Icons.coffee_outlined);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppThemeColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemeColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(type, color: AppThemeColors.textPrimaryColor),
                const SizedBox(height: 4),
                AppTextWidget.verySmall('${item['date']} • ${item['status']}', color: AppThemeColors.muted),
              ],
            ),
          ),
          AppTextWidget.small(item['time'], color: AppThemeColors.textPrimaryColor),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final String title;
  final String time;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _AttendanceCard({
    Key? key,
    required this.title,
    required this.time,
    required this.subtitle,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      color: AppThemeColors.dashboardCardBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // circular icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              AppTextWidget.small(title, color: AppThemeColors.textSecondaryColor),
            ],
          ),
          const SizedBox(height: 12),
          AppTextWidget.large(time, color: AppThemeColors.textPrimaryColor),
          const SizedBox(height: 6),
          AppTextWidget.small(subtitle, color: AppThemeColors.muted),
        ],
      ),
    );
  }
}

class _AttendanceSmallCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _AttendanceSmallCard({required this.title, required this.value, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppThemeColors.primaryLightColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppThemeColors.primaryColor),
              ),
              const SizedBox(width: 12),AppTextWidget.verySmall(title, color: AppThemeColors.textSecondaryColor),
              const SizedBox(height: 6),

            ],
          ),
          AppTextWidget.large(value),

        ],
      ),
    );
  }
}
