

import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../models/attendance_activity.dart';

class AdminActivityTile extends StatelessWidget {
  final AttendanceActivity activity;

  const AdminActivityTile({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCheckIn = AppHelper.isCheckIn(activity.punchType);

    final Color statusColor =
    isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;

    final IconData icon =
    isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

    final String type =
    AppHelper.getPunchTypeLabel(activity.punchType);

    final DateTime? punchDateTime =
    AppHelper.parseDateTime(activity.punchDate);

    final String userName =
    (activity.userName?.trim().isNotEmpty ?? false)
        ? activity.userName!
        : "User";

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
          /// 🔹 STATUS ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),

          const SizedBox(width: 14),
          /// 🔹 CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 USER NAME
                AppTextWidget.medium(
                  userName,
                  color: AppThemeColors.textPrimaryColor,
                ),

                const SizedBox(height: 4),

                /// 📅 DATE
                Row(
                  children: [
                    AppIconWidget.small(
                      AppConstIcons.dateIcon,
                      color: statusColor.withOpacity(.5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: AppTextWidget.small(
                        AppHelper.formatShortDate(punchDateTime),
                        color: AppThemeColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              AppTextWidget.medium(
                type,
                color: statusColor,
              ),

              /// ⏰ TIME
              AppTextWidget.medium(
                AppHelper.formatTime(punchDateTime),
                color: AppThemeColors.textPrimaryColor,
              ),
            ],
          )

        ],
      ),
    );
  }
}
