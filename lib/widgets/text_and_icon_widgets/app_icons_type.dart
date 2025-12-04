import 'package:flutter/cupertino.dart';

// Assuming this is where AppIconStyles is defined.
import '../../core/constants/icons_style.dart';

class AppIconWidget extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  // FIX: Constructor is no longer const
  AppIconWidget({
    required this.icon,
    this.size = AppIconStyles.medium,
    Color? color, // Parameter is nullable
    super.key,
  }) : color = color ?? AppIconStyles.defaultColor; // Default value assigned here


  @override
  Widget build(BuildContext context) {
    final double containerSize = _getContainerSize(size);
    // Determine the icon color to be used
    final Color iconColor = color ?? AppIconStyles.defaultColor;

    return Icon(
      icon,
      size: size,
      color: iconColor, // Use the determined iconColor
    );
  }

  /// Map icon size → container size
  double _getContainerSize(double iconSize) {
    if (iconSize == AppIconStyles.small) return 26;
    if (iconSize == AppIconStyles.medium) return 30;
    if (iconSize == AppIconStyles.large) return 40;
    if (iconSize == AppIconStyles.veryLarge) return 50;
    return iconSize + 10; // fallback
  }

  // --- Factory constructors with background control (Updated to remove unused 'color' default) ---

  factory AppIconWidget.small(
      IconData icon, {
        Color? color, // Use nullable color
      }) {
    return AppIconWidget(
      icon: icon,
      size: AppIconStyles.small,
      color: color,
    );
  }

  factory AppIconWidget.medium(
      IconData icon, {
        Color? color, // Use nullable color
      }) {
    return AppIconWidget(
      icon: icon,
      size: AppIconStyles.medium,
      color: color,
    );
  }

  factory AppIconWidget.large(
      IconData icon, {
        Color? color, // Use nullable color
      }) {
    return AppIconWidget(
      icon: icon,
      size: AppIconStyles.large,
      color: color,
    );
  }

  factory AppIconWidget.veryLarge(
      IconData icon, {
        Color? color, // Use nullable color
      }) {
    return AppIconWidget(
      icon: icon,
      size: AppIconStyles.veryLarge,
      color: color,
    );
  }
}