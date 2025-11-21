import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';

class UserActivityScreen extends StatelessWidget {
  const UserActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy activity list
    final activities = [
      {"type": "checkin", "time": "10:20 AM", "date": "Apr 23, 2025"},
      {"type": "checkout", "time": "07:10 PM", "date": "Apr 23, 2025"},
      {"type": "checkin", "time": "10:18 AM", "date": "Apr 22, 2025"},
      {"type": "checkout", "time": "07:05 PM", "date": "Apr 22, 2025"},
      {"type": "checkin", "time": "10:25 AM", "date": "Apr 21, 2025"},
      {"type": "checkout", "time": "07:15 PM", "date": "Apr 21, 2025"},
    ];

    return SafeArea(
      child: Column(
        children: [

          // Card Wrapper
          Expanded(
            child:  ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: activities.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (_, idx) {
                  final activity = activities[idx];
                  final bool isCheckIn = activity["type"] == "checkin";

                  return _buildActivityTile(
                    type: activity["type"]!,
                    time: activity["time"]!,
                    date: activity["date"]!,
                    isCheckIn: isCheckIn,
                  );
                },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required String type,
    required String time,
    required String date,
    required bool isCheckIn,
  }) {
    final Color color =
    isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;

    final IconData icon =
    isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

    return CommonCardWidget(
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),

          const SizedBox(width: 14),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(
                  isCheckIn ? "Check In" : "Check Out",
                  color: AppThemeColors.textPrimaryColor,
                ),
                const SizedBox(height: 4),
                AppTextWidget.verySmall(
                  date,
                  color: AppThemeColors.muted,
                ),
              ],
            ),
          ),

          // Time
          AppTextWidget.medium(
            time,
            color: AppThemeColors.textPrimaryColor,
          )
        ],
      ),
    );
  }
}
