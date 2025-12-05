

import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme_colors.dart';
import '../../../../data/utils/app_helper.dart';
import '../../../../models/attendance_activity.dart';
import '../../../../widgets/card/common_card.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class AttendanceStatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const AttendanceStatusBadge({
    Key? key,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          AppTextWidget.verySmall(status, color: color),
        ],
      ),
    );
  }
}



class AttendanceCard extends StatelessWidget {
  final String title;
  final String time;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isRecorded;

  const AttendanceCard({
    Key? key,
    required this.title,
    required this.time,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isRecorded,
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              AppTextWidget.small(title, color: AppThemeColors.textSecondaryColor),
            ],
          ),
          const SizedBox(height: 14),
          AppTextWidget.large(time, color: AppThemeColors.textPrimaryColor),
          const SizedBox(height: 6),
          Row(
            children: [
              if (isRecorded)
                Icon(Icons.check_circle, size: 12, color: AppThemeColors.successColor),
              if (isRecorded) const SizedBox(width: 4),
              Expanded(
                child: AppTextWidget.small(subtitle, color: AppThemeColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.verySmall(title, color: AppThemeColors.textSecondaryColor),
                const SizedBox(height: 4),
                AppTextWidget.large(value, color: AppThemeColors.textPrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ActivityTile extends StatelessWidget {
  final AttendanceActivity activity;

  const ActivityTile({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCheckIn = AppHelper.isCheckIn(activity.punchType);
    final Color bgColor = isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;
    final Color iconColor = isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;
    final IconData icon = isCheckIn ? Icons.login_rounded : Icons.logout_rounded;
    final String type = AppHelper.getPunchTypeLabel(activity.punchType);
    final DateTime? punchDateTime = AppHelper.parseDateTime(activity.punchDate);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppThemeColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppThemeColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.medium(type, color: AppThemeColors.textPrimaryColor),
                const SizedBox(height: 4),
                if (AppHelper.isValidLocation(activity.lat, activity.long))
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: AppThemeColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppTextWidget.verySmall(
                          'Lat: ${activity.lat}, Long: ${activity.long}',
                          color: AppThemeColors.muted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextWidget.medium(
                AppHelper.formatTime(punchDateTime),
                color: AppThemeColors.textPrimaryColor,
              ),
              const SizedBox(height: 4),
              AppTextWidget.verySmall(
                AppHelper.formatShortDate(punchDateTime),
                color: AppThemeColors.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class EmptyActivityState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyActivityState({
    Key? key,
    this.title = 'No activity today',
    this.subtitle = 'Check in to start tracking your time',
    this.icon = Icons.event_busy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppThemeColors.muted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppTextWidget.medium(
            title,
            color: AppThemeColors.textSecondaryColor,
          ),
          const SizedBox(height: 8),
          AppTextWidget.small(
            subtitle,
            color: AppThemeColors.muted,
          ),
        ],
      ),
    );
  }
}

// ===============