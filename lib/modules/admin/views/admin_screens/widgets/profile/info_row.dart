

import 'package:flutter/material.dart';

import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';



class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(label),
                AppTextWidget.medium(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
