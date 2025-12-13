
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.large("Admin Dashboard"),
        const SizedBox(height: 4),
        AppTextWidget.small(
          "Monitor attendance, leaves & employees",
          color: AppThemeColors.textSecondaryColor,
        ),
      ],
    );
  }
}
