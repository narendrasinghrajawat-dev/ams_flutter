import 'package:flutter/material.dart';

import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class AttendanceStatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const AttendanceStatusBadge({
    Key? key,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          AppTextWidget.verySmall(status, color: color),
        ],
      ),
    );
  }
}
