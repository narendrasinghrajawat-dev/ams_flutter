import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String? title;
  final String? value;
  final Color? backgroundColor;
  final Color? accentColor;

  const SummaryCard({
    Key? key,
    this.title,
    this.value,
    this.backgroundColor,
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      color: backgroundColor?.withValues(alpha: .2) ?? Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget.small(title ?? "", color: Colors.grey.shade700, maxLines: 1,),
          AppTextWidget.large(value ?? "", color: accentColor ?? Theme.of(context).primaryColor, maxLines: 1,
          ),
        ],
      ),
    );
  }
}