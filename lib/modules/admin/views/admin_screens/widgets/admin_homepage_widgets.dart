

import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
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
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      color: AppThemeColors.dashboardCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(0), // Adjusted padding here for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppThemeColors.primaryColor, size: 24),
                ),
                AppTextWidget.medium(
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
  final VoidCallback? onTap; // <--- optional tap callback

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  /// Factory that creates an ActivityItem for a domain object and attaches a navigation onTap.
  factory ActivityItem.fromActivity(dynamic activity) {
    if (activity is ApplyLeaveRequest) {
      final item = ActivityItem(
        icon: Icons.beach_access_rounded,
        title: '${activity.userName ?? 'Employee'} applied for leave',
        subtitle: 'From ${AppHelper.formatDateString(activity.startDate)} to ${AppHelper.formatDateString(activity.endDate)}',
        color: AppThemeColors.warningColor,
        // onTap: () {
        //   // Navigate to admin leave detail screen.
        //   // Replace '/admin/leave_detail' with your actual route.
        //   // We pass the whole activity as arguments so destination can use Get.arguments
        //   Get.toNamed(AppRoutes.adminLeavesScreen, arguments: activity);
        // },
      );
      return item;
    } else if (activity is AttendanceActivity) {
      final isClockIn = activity.punchType == 'IN';
      final time = AppHelper.formatTimeString(activity.punchTime) ?? 'N/A';
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
        // onTap: () {
        //   // Navigate to general activity / attendance screen.
        //   // Replace '/activity-log' with the route that shows attendance details.
        //   Get.toNamed(AppRoutes.adminEmployeeScreen, arguments: {
        //     'activity': activity,
        //     // Optional: you can pass additional info so the screen can open filtered view
        //     'focusType': 'attendance',
        //   });
        // },
      );
    }

    // Fallback
    return const ActivityItem(
      icon: Icons.help_outline,
      title: 'Unknown Activity',
      subtitle: 'Data type error',
      color: Colors.grey,
      onTap: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CommonCardWidget(
        color: AppThemeColors.cardBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    AppTextWidget.small(
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
      ),
    ).marginOnly(bottom: 8);
  }
}
