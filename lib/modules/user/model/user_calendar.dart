


class UserCalendarResponse {
  final int year;
  final Map<String, CalendarDay> data;

  UserCalendarResponse({
    required this.year,
    required this.data,
  });

  factory UserCalendarResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>;

    return UserCalendarResponse(
      year: json['year'],
      data: rawData.map(
            (key, value) =>
            MapEntry(key, CalendarDay.fromJson(value)),
      ),
    );
  }
}


class CalendarDay {
  final DateTime date;
  final String day;
  final bool isHoliday;
  final String? holidayName;
  final String? holidayType;
  final bool isWeekend;
  final PunchInfo? punch;

  CalendarDay({
    required this.date,
    required this.day,
    required this.isHoliday,
    this.holidayName,
    this.holidayType,
    required this.isWeekend,
    this.punch,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: DateTime.parse(json['date']),
      day: json['day'],
      isHoliday: json['isHoliday'],
      holidayName: json['holidayName'],
      holidayType: json['holidayType'],
      isWeekend: json['isWeekend'],
      punch:
      json['punch'] != null ? PunchInfo.fromJson(json['punch']) : null,
    );
  }
}

class PunchInfo {
  final String punchIn;
  final String punchOut;
  final String duration;

  PunchInfo({
    required this.punchIn,
    required this.punchOut,
    required this.duration,
  });

  factory PunchInfo.fromJson(Map<String, dynamic> json) {
    return PunchInfo(
      punchIn: json['punchIn'],
      punchOut: json['punchOut'],
      duration: json['duration'],
    );
  }
}
