

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../model/user_calendar.dart';
import 'day_cell.dart';


class MonthCalendarWidget extends StatelessWidget {
  final int year;
  final int month;
  final Map<DateTime, CalendarDay> calendarMap;

  const MonthCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.calendarMap,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final monthName = DateFormat.MMMM().format(DateTime(year, month));

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (_, index) {
                final day = index + 1;
                final date = DateTime(year, month, day);

                return DayCellWidget(
                  date: date,
                  calendarDay: calendarMap[date],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
