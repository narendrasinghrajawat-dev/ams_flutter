
import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';


class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCardWidget(this.title, this.value, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CommonCardWidget(
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.verySmall(title),
                AppTextWidget.large(value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
