
import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';


class AdminDateFilter extends StatelessWidget {
  const AdminDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextWidget.medium("Date"),
          Row(
            children: const [
              _FilterChip(label: "Today"),
              _FilterChip(label: "Week"),
              _FilterChip(label: "Month"),
            ],
          )
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: label == "Today",
        onSelected: (_) {},
      ),
    );
  }
}

