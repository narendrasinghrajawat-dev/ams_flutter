

import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_icons_type.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../models/attendance_activity.dart';

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
                      AppIconWidget.small(AppConstIcons.dateIcon,color: AppHelper.isCheckIn(activity.punchType) ? AppThemeColors.successColor.withOpacity(.5) : AppThemeColors.errorColor.withOpacity(.5),),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextWidget.medium(
                AppHelper.formatTime(punchDateTime),
                color: AppThemeColors.textPrimaryColor,
              ),

            ],
          ),
        ],
      ),
    );
  }
}
