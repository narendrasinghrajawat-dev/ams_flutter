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
      padding: 14,
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextWidget.small(title, color: AppThemeColors.textSecondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextWidget.large(time, color: AppThemeColors.textPrimaryColor),
          const SizedBox(height: 6),
          Row(
            children: [
              if (isRecorded) ...[
                Icon(Icons.check_circle_rounded, size: 14, color: AppThemeColors.successColor),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: AppTextWidget.verySmall(subtitle, color: AppThemeColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
