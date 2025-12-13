import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
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
        AppTextWidget.medium("Recent Activity"),
        const SizedBox(height: 8),

        /// 🔥 ONLY THIS PART IS REACTIVE
        Obx(() {
          final activities = c.recentActivityList;

          if (activities.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: AppTextWidget.small(
                  "No activity found for selected date",
                  color: AppThemeColors.textSecondaryColor,
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (_, index) {
              final item = activities[index];
              return _ActivityItem(item: item);
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

    /// ATTENDANCE ACTIVITY
    if (item.runtimeType.toString() == 'AttendanceActivity') {
      icon = Icons.login_rounded;
      title = item.userName ?? 'Employee';
      subtitle = 'Checked ${item.punchType == "1" ? "in" : "out"} at ${AppHelper.formatTimeString(item.punchTime) ?? '--'}';
    }

    /// LEAVE ACTIVITY
    else if (item.runtimeType.toString() == 'ApplyLeaveRequest') {
      icon = Icons.beach_access_rounded;
      title = item.userName ?? 'Employee';
      subtitle = 'Leave request (${item.leaveStatus})';
    }

    return CommonCardWidget(
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppThemeColors.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppThemeColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(title),
                const SizedBox(height: 2),
                AppTextWidget.verySmall(
                  subtitle,
                  color: AppThemeColors.textSecondaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


