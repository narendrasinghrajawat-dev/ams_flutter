
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';


class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCardWidget(this.title, this.value, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
