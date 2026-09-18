import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';

class CommonCardWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double padding;
  final bool isShowBoxShadow;
  final Color? color;
  final Border? border;

  const CommonCardWidget({
    super.key,
    required this.child,
    this.borderRadius = 14,
    this.padding = 12,
    this.isShowBoxShadow = true,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color ?? AppThemeColors.cardBackgroundColor,
        border: border ?? Border.all(width: 1, color: AppThemeColors.cardBorderColor),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isShowBoxShadow
            ? [
                BoxShadow(
                  color: isDark
                      ? const Color(0x33000000)
                      : const Color(0x08000000),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
