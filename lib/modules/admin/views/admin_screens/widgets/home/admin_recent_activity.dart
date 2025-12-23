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

          return LayoutBuilder(
            builder: (context, constraints) {
              /// 🧠 Responsive columns
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb ? 2: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio:kIsWeb ? 11 : 4.4,
                ),
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
      color = AppHelper.getPunchTypeColor(item.punchType);

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
      color: color.withOpacity(0.06),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 ICON
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),

          const SizedBox(width: 12),

          /// 🔹 CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 6),

                /// 📅 DATE CHIP

              ],
            ),
          ),

          /// ⏰ TIME
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextWidget.verySmall(
                time,
                color: AppThemeColors.textPrimaryColor,
              ),
              AppTextWidget.small(
                date,
              ),
            ],
          )

        ],
      ),
    );
  }
}


