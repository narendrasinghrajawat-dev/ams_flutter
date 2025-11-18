

import 'package:attedance_management_system/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Used to access the theme context
import '../../core/constants/app_theme_colors.dart';

/// A reusable widget to apply predefined text styles, dynamic theme colors,
/// and common layout properties (align, maxLines) consistently.
class AppTextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;

  /// Determines the fallback color category if [color] is null.
  final Color Function() defaultColorGetter;

  const AppTextWidget({
    super.key,
    required this.text,
    required this.style,
    this.color,
    this.align,
    this.maxLines,
    required this.defaultColorGetter,
  });

  // --- FACTORY CONSTRUCTORS (The replacement for your static methods) ---

  factory AppTextWidget.veryLarge(
      String text, {
        Key? key,
        Color? color,
        TextAlign? align,
        int? maxLines,
      }) =>
      AppTextWidget(
        key: key,
        text: text,
        style: AppStyles.veryLarge,
        color: color,
        align: align,
        maxLines: maxLines,
        defaultColorGetter: () => AppThemeColors.textLargeColor,
      );

  factory AppTextWidget.large(
      String text, {
        Key? key,
        Color? color,
        TextAlign? align,
        int? maxLines,
      }) =>
      AppTextWidget(
        key: key,
        text: text,
        style: AppStyles.large,
        color: color,
        align: align,
        maxLines: maxLines,
        defaultColorGetter: () => AppThemeColors.textLargeColor,
      );

  factory AppTextWidget.medium(
      String text, {
        Key? key,
        Color? color,
        TextAlign? align,
        int? maxLines,
      }) =>
      AppTextWidget(
        key: key,
        text: text,
        style: AppStyles.medium,
        color: color,
        align: align,
        maxLines: maxLines,
        defaultColorGetter: () => AppThemeColors.textMediumColor,
      );

  factory AppTextWidget.small(
      String text, {
        Key? key,
        Color? color,
        TextAlign? align,
        int? maxLines,
      }) =>
      AppTextWidget(
        key: key,
        text: text,
        style: AppStyles.small,
        color: color,
        align: align,
        maxLines: maxLines,
        defaultColorGetter: () => AppThemeColors.textSmallColor,
      );

  factory AppTextWidget.verySmall(
      String text, {
        Key? key,
        Color? color,
        TextAlign? align,
        int? maxLines,
      }) =>
      AppTextWidget(
        key: key,
        text: text,
        style: AppStyles.verySmall,
        color: color,
        align: align,
        maxLines: maxLines,
        defaultColorGetter: () => AppThemeColors.textSmallColor,
      );


  @override
  Widget build(BuildContext context) {
    // Determine the final color:
    // 1. Use the explicitly provided color, OR
    // 2. Use the dynamically determined default color based on the size category.
    final finalColor = color ?? defaultColorGetter();

    return Text(
      // Use .tr() extension for GetX localization support
      text.tr,
      style: style.copyWith(color: finalColor),
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

