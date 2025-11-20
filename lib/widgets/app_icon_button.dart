import 'package:flutter/material.dart';

import '../core/constants/icons_style.dart';

class AppIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? color; // This is the color for the icon itself

  // FIX 1: Removed the initialization list that used the non-constant defaultColor.
  // The constructor is now properly const.
  const AppIconButtonWidget({
    required this.icon,
    required this.onPressed,
    this.size = AppIconStyles.medium,
    this.color, // Color is now nullable with no default value here.
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double containerSize = _getContainerSize(size);

    // FIX 2: Resolve the icon color using the null-aware operator inside build().
    // If 'color' is null, fall back to AppIconStyles.defaultColor (which is dynamic).
    final Color iconColor = color ?? AppIconStyles.defaultColor;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(containerSize / 2),
      child: Padding( // Added Padding to ensure the tap target feels the same size
        padding: EdgeInsets.all((containerSize - size) / 2),
        child: Icon(icon, size: size, color: iconColor), // Use the resolved icon color
      ),
    );
  }

  /// Map icon size → container size
  double _getContainerSize(double iconSize) {
    if (iconSize == AppIconStyles.small) return 24;
    if (iconSize == AppIconStyles.medium) return 30;
    if (iconSize == AppIconStyles.large) return 40;
    if (iconSize == AppIconStyles.veryLarge) return 50;
    return iconSize + 10; // fallback
  }

  // --- Predefined sizes with background control (Factory Constructors Fixed) ---

  // FIX 4: Removed the non-constant default value from optional parameters in factories.
  // By using Color? color (nullable), we defer the default logic to the main const constructor.

  factory AppIconButtonWidget.small({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isSetBackgroundColor = true,
  }) {
    return AppIconButtonWidget(
      icon: icon,
      onPressed: onPressed,
      size: AppIconStyles.small,
      color: color,
    );
  }

  factory AppIconButtonWidget.medium({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isSetBackgroundColor = true,
  }) {
    return AppIconButtonWidget(
      icon: icon,
      onPressed: onPressed,
      size: AppIconStyles.medium,
      color: color,
    );
  }

  factory AppIconButtonWidget.large({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isSetBackgroundColor = true,
  }) {
    return AppIconButtonWidget(
      icon: icon,
      onPressed: onPressed,
      size: AppIconStyles.large,
      color: color,
    );
  }

  factory AppIconButtonWidget.veryLarge({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isSetBackgroundColor = true,
  }) {
    return AppIconButtonWidget(
      icon: icon,
      onPressed: onPressed,
      size: AppIconStyles.veryLarge,
      color: color,
    );
  }
}