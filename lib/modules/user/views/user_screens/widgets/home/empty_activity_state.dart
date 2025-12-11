
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class EmptyActivityState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyActivityState({
    Key? key,
    this.title = 'No activity today',
    this.subtitle = 'Check in to start tracking your time',
    this.icon = Icons.event_busy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppThemeColors.muted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppTextWidget.medium(
            title,
            color: AppThemeColors.textSecondaryColor,
          ),
          const SizedBox(height: 8),
          AppTextWidget.small(
            subtitle,
            color: AppThemeColors.muted,
          ),
        ],
      ),
    );
  }
}
