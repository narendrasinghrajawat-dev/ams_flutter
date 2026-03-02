

import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
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
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconWidget.medium(
                icon, color: AppThemeColors.iconColor,
              ),
              SizedBox(width: 5,),
              AppTextWidget.verySmall(
                label,
                color: AppThemeColors.muted,
              ),
            ],
          ),

          AppTextWidget.small(
            value,
            color: AppThemeColors.textPrimaryColor,
          ),
        ],
      ),
    );
  }
}
