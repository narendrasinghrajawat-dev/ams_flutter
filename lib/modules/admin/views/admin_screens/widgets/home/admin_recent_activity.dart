import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../models/apply_leave_request.dart';
import '../../../../../models/attendance_activity.dart';
import '../../../../controller/admin_home_controller.dart';
import '../../../../../../core/constants/app_theme_colors.dart';

class AdminRecentActivity extends StatelessWidget {
  const AdminRecentActivity({super.key});

  AdminHomeController get c => Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.medium(
          "Recent Activity",
          color: AppThemeColors.textPrimaryColor,
        ),
        const SizedBox(height: 10),

        Obx(() {
          final activities = c.recentActivityList;

          if (activities.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: AppTextWidget.small(
                  "No activity found for selected date",
                  color: AppThemeColors.textSecondaryColor,
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth >= 700;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final item = activities[index];
                  return _ActivityItem(item: item);
                },
              );
            },
          );
        }),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final dynamic item;

  const _ActivityItem({required this.item});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.info_outline;
    String title = '';
    String subtitle = '';
    String time = '--';
    String date = '--';
    Color color = AppThemeColors.primaryColor;

    /// ---------------- ATTENDANCE ACTIVITY ----------------
    if (item is AttendanceActivity) {
      final bool isCheckIn = item.punchType == "1";

      icon = isCheckIn ? Icons.login_rounded : Icons.logout_rounded;
      color = isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;

      title = item.userName ?? 'Employee';
      time = AppHelper.formatTimeString(item.punchTime) ?? '--';
      date = AppHelper.formatDateString(item.punchDate) ?? '--';
      subtitle = 'Checked ${isCheckIn ? "in" : "out"}';
    }

    /// ---------------- LEAVE ACTIVITY ----------------
    else if (item is ApplyLeaveRequest) {
      icon = Icons.beach_access_rounded;
      color = AppThemeColors.warningColor;

      title = item.userName ?? 'Employee';
      subtitle = 'Leave request (${item.leaveStatus})';
      time = AppHelper.formatTimeString(item.createdDate) ?? '--';
      date = AppHelper.formatDateString(item.createdDate) ?? '--';
    }

    return CommonCardWidget(
      padding: 12,
      borderRadius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextWidget.small(
                  title,
                  color: AppThemeColors.textPrimaryColor,
                ),
                const SizedBox(height: 2),
                AppTextWidget.verySmall(
                  subtitle,
                  color: AppThemeColors.textSecondaryColor,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppThemeColors.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 11,
                  color: AppThemeColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
