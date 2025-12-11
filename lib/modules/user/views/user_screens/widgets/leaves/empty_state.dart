
import 'package:flutter/material.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  const EmptyStateWidget({Key? key, this.message = 'No data'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.info_outline, size: 36, color: AppThemeColors.muted),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: AppThemeColors.muted)),
        ]),
      ),
    );
  }
}
