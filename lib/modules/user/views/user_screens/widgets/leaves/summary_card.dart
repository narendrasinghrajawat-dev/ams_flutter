import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String? title;
  final String? value;
  final Color? backgroundColor;
  final Color? accentColor;
  final Color? color;

  const SummaryCard({
    Key? key,
    this.title,
    this.value,
    this.backgroundColor,
    this.accentColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = color ?? accentColor ?? AppThemeColors.primaryColor;
    return CommonCardWidget(
      color: backgroundColor?.withOpacity(0.12) ?? AppThemeColors.cardBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget.small(
            title ?? "",
            color: AppThemeColors.textSecondaryColor,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          AppTextWidget.large(
            value ?? "",
            color: effectiveAccent,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}