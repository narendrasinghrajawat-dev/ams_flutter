import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';

class CommonContainerWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double padding;
  final bool isShowBoxShadow;
  final Color? color;
  final Border? border;

  const CommonContainerWidget({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.padding = 10,
    this.isShowBoxShadow = false,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = color ?? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9));
    final borderColor = isDark ? const Color(0xFF273548) : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bgColor,
        border: border ?? Border.all(color: borderColor, width: 1),
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