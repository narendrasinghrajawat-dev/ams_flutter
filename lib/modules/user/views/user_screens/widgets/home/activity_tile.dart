import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../models/attendance_activity.dart';

class UserActivityTile extends StatelessWidget {
  final AttendanceActivity activity;

  const UserActivityTile({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCheckIn = AppHelper.isCheckIn(activity.punchType);
    final Color statusColor = isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;
    final IconData icon = isCheckIn ? Icons.login_rounded : Icons.logout_rounded;
    final String type = AppHelper.getPunchTypeLabel(activity.punchType);
    final DateTime? punchDateTime = AppHelper.parseDateTime(activity.punchDate);

    return CommonCardWidget(
      padding: 12,
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextWidget.medium(type, color: AppThemeColors.textPrimaryColor),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12, color: AppThemeColors.muted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        AppHelper.formatShortDate(punchDateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemeColors.muted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppHelper.formatTime(punchDateTime),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
