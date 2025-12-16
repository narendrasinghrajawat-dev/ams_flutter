
import 'package:flutter/material.dart';

import '../../../../model/user_calendar.dart';


class DayCellWidget extends StatelessWidget {
  final DateTime date;
  final CalendarDay? calendarDay;

  const DayCellWidget({
    super.key,
    required this.date,
    this.calendarDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = Colors.transparent;
    Color textColor = theme.textTheme.bodyMedium!.color!;

    if (calendarDay?.isHoliday == true) {
      backgroundColor = Colors.red.withOpacity(0.15);
      textColor = Colors.red;
    } else if (calendarDay?.punch != null) {
      backgroundColor = theme.primaryColor.withOpacity(0.12);
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              '${date.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 4),

            // Holiday
            if (calendarDay?.isHoliday == true)
              Text(
                calendarDay?.holidayName ?? 'Holiday',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
              )

            // Punch info
            else if (calendarDay?.punch != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calendarDay!.punch!.punchIn,
                    style: const TextStyle(fontSize: 9),
                  ),
                  Text(
                    calendarDay!.punch!.punchOut,
                    style: const TextStyle(fontSize: 9),
                  ),
                  Text(
                    calendarDay!.punch!.duration,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      )
    );
  }
}
