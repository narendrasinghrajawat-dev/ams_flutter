

import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppThemeColors.iconColor,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.verySmall(
                label,
                color: AppThemeColors.muted,
              ),
              AppTextWidget.small(
                value,
                color: AppThemeColors.textPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
