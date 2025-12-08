

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../models/apply_leave_request.dart';
import '../../../../models/attendance_activity.dart';


// --- STAT CARD WIDGET ---
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      color: AppThemeColors.dashboardCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16), // Adjusted padding here for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppThemeColors.primaryColor, size: 24),
                ),
                AppTextWidget.veryLarge(
                  value,
                  color: AppThemeColors.textPrimaryColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppTextWidget.small(
              title,
              color: AppThemeColors.textPrimaryColor,
              maxLines: 1,
            ),
            AppTextWidget.verySmall(
              subtitle,
              color: AppThemeColors.textSecondaryColor,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// --- ACTION CARD WIDGET ---
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120, // Slightly reduced width for more actions
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppThemeColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            AppTextWidget.small(
              title,
              color: AppThemeColors.textPrimaryColor,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// --- ACTIVITY ITEM WIDGET ---
class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    Key? key,
  }) : super(key: key);

// ... inside ActivityItem class ...

  factory ActivityItem.fromActivity(dynamic activity) {
    if (activity is ApplyLeaveRequest) {
      // ... (Leave logic remains the same)
      return ActivityItem(
        icon: Icons.beach_access_rounded,
        title: '${activity.userName ?? 'Employee'} applied for leave',
        subtitle: 'From ${activity.startDate} to ${activity.endDate}',
        color: AppThemeColors.warningColor,
      );
    } else if (activity is AttendanceActivity) {
      // --- UPDATED LOGIC HERE ---
      final isClockIn = activity.punchType == 'IN';
      final time = activity.punchTime ?? 'N/A';

      // Simple late check (Assumes punchTime format is comparable to '09:00:00')
      // This is less robust than the controller's logic but necessary for display
      final isLate = isClockIn && (time.compareTo('09:00:00') > 0);

      Color color;
      String title;

      if (isClockIn) {
        title = isLate ? 'Late Clock-In - ${activity.userName ?? 'Employee'}' : '${activity.userName ?? 'Employee'} Clocked In';
        color = isLate ? AppThemeColors.errorColor : AppThemeColors.successColor;
      } else {
        title = '${activity.userName ?? 'Employee'} Clocked Out';
        color = AppThemeColors.primaryColor;
      }

      return ActivityItem(
        icon: isClockIn ? Icons.login_rounded : Icons.logout_rounded,
        title: title,
        subtitle: 'At $time',
        color: color,
      );
    }
    // Fallback for unknown type
    return const ActivityItem(
      icon: Icons.help_outline,
      title: 'Unknown Activity',
      subtitle: 'Data type error',
      color: Colors.grey,
    );
  }

// ... rest of the widget ...

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      color: AppThemeColors.cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Adjusted padding
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.small( // Changed to small for list context
                    title,
                    color: AppThemeColors.textPrimaryColor,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  AppTextWidget.verySmall(
                    subtitle,
                    color: AppThemeColors.textSecondaryColor,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    ).marginOnly(bottom: 8);
  }
}