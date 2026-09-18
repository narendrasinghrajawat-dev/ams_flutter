


class UserCalendarResponse {
  final int year;
  final Map<String, CalendarDay> data;

  UserCalendarResponse({
    required this.year,
    required this.data,
  });

  factory UserCalendarResponse.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['data'] ?? json;
    final Map<String, dynamic> map = raw is Map<String, dynamic>
        ? ((raw['data'] is Map<String, dynamic>) ? raw['data'] as Map<String, dynamic> : raw)
        : <String, dynamic>{};

    final yearVal = json['year'] ?? (raw is Map ? raw['year'] : null) ?? DateTime.now().year;

    final parsedData = <String, CalendarDay>{};
    map.forEach((k, v) {
      if (v is Map<String, dynamic>) {
        parsedData[k] = CalendarDay.fromJson(v);
      }
    });

    return UserCalendarResponse(
      year: yearVal is int ? yearVal : int.tryParse(yearVal.toString()) ?? DateTime.now().year,
      data: parsedData,
    );
  }
}

class CalendarDay {
  final DateTime date;
  final String day;
  final String status;
  final bool isHoliday;
  final String? holidayName;
  final String? holidayType;
  final bool isWeekend;
  final PunchInfo? punch;
  final dynamic leave;

  CalendarDay({
    required this.date,
    required this.day,
    this.status = '',
    required this.isHoliday,
    this.holidayName,
    this.holidayType,
    required this.isWeekend,
    this.punch,
    this.leave,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now() : DateTime.now(),
      day: json['day']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isHoliday: json['isHoliday'] == true,
      holidayName: json['holidayName']?.toString(),
      holidayType: json['holidayType']?.toString(),
      isWeekend: json['isWeekend'] == true,
      punch: json['punch'] != null && json['punch'] is Map<String, dynamic>
          ? PunchInfo.fromJson(json['punch'] as Map<String, dynamic>)
          : null,
      leave: json['leave'],
    );
  }
}

class PunchInfo {
  final String? punchIn;
  final String? punchOut;
  final String? duration;

  PunchInfo({
    this.punchIn,
    this.punchOut,
    this.duration,
  });

  factory PunchInfo.fromJson(Map<String, dynamic> json) {
    return PunchInfo(
      punchIn: json['punchIn']?.toString(),
      punchOut: json['punchOut']?.toString(),
      duration: json['duration']?.toString(),
    );
  }
}
