import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 14,
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextWidget.verySmall(title, color: AppThemeColors.textSecondaryColor),
                const SizedBox(height: 2),
                AppTextWidget.large(value, color: AppThemeColors.textPrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
