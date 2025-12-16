import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/user_home_controller.dart';
import '../../../../model/user_calendar.dart';
import 'month_calendar.dart';

class YearCalendarScreen extends StatelessWidget {
  YearCalendarScreen({super.key});

  final UserHomeController controller = Get.find<UserHomeController>();

  /// Convert Map<String, CalendarDay> → Map<DateTime, CalendarDay>
  Map<DateTime, CalendarDay> buildCalendarMap(
      Map<String, CalendarDay> data,
      ) {
    return data.map(
          (key, value) => MapEntry(
        DateTime.parse(key),
        value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Calendar'),
      ),
      body: Obx(() {
        final response = controller.userCalendar.value;

        if (response == null) {
          return const Center(child: Text('No calendar data'));
        }

        final calendarMap = buildCalendarMap(response.data);

        return ListView.builder(
          itemCount: 12,
          itemBuilder: (_, index) {
            final month = index + 1;
            return MonthCalendarWidget(
              year: response.year,
              month: month,
              calendarMap: calendarMap,
            );
          },
        );
      }),
    );
  }
}
