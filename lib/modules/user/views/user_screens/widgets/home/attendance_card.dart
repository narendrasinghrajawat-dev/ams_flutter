
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';


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
