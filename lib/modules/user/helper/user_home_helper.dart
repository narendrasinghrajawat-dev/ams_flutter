// lib/modules/user/helpers/user_home_helper.dart

import 'package:collection/collection.dart';
import '../../../data/utils/app_helper.dart';
import '../../models/attendance_activity.dart';

class UserHomeHelper {
  /// ---------- TODAY HELPERS (USING punchTime ONLY) ----------

  static AttendanceActivity? todayCheckIn(
      List<AttendanceActivity> activities,
      ) {
    return activities.firstWhereOrNull(
          (a) =>
      AppHelper.isCheckIn(a.punchType) &&
          _isToday(a.punchTime),
    );
  }

  static AttendanceActivity? todayCheckOut(
      List<AttendanceActivity> activities,
      ) {
    return activities.firstWhereOrNull(
          (a) =>
      AppHelper.isCheckOut(a.punchType) &&
          _isToday(a.punchTime),
    );
  }

  static List<AttendanceActivity> todayActivities(
      List<AttendanceActivity> activities,
      ) {
    return activities
        .where((a) => _isToday(a.punchTime))
        .toList();
  }

  /// ---------- TIMER / DURATION ----------

  static Duration elapsedToday(
      AttendanceActivity? checkIn,
      AttendanceActivity? checkOut,
      ) {
    if (checkIn == null) return Duration.zero;

    final inTime = AppHelper.parseDateTime(checkIn.punchTime);
    if (inTime == null) return Duration.zero;

    if (checkOut != null) {
      final outTime = AppHelper.parseDateTime(checkOut.punchTime);
      if (outTime == null) return Duration.zero;
      return outTime.difference(inTime);
    }

    return DateTime.now().difference(inTime);
  }

  /// ---------- STATS ----------

  static double totalHours(
      List<AttendanceActivity> activities,
      ) {
    double total = 0;

    final grouped = <String, List<AttendanceActivity>>{};

    for (final a in activities) {
      final dt = AppHelper.parseDateTime(a.punchTime);
      if (dt == null) continue;

      final key = AppHelper.formatDate(dt);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(a);
    }

    for (final day in grouped.values) {
      final inAct =
      day.firstWhereOrNull((a) => AppHelper.isCheckIn(a.punchType));
      final outAct =
      day.firstWhereOrNull((a) => AppHelper.isCheckOut(a.punchType));

      if (inAct != null && outAct != null) {
        final inTime = AppHelper.parseDateTime(inAct.punchTime);
        final outTime = AppHelper.parseDateTime(outAct.punchTime);
        if (inTime != null && outTime != null) {
          total += outTime.difference(inTime).inMinutes / 60;
        }
      }
    }

    return total;
  }

  static int totalDays(List<AttendanceActivity> activities) {
    return activities.where((a) => AppHelper.isCheckIn(a.punchType)).map((a) {
      final dt = AppHelper.parseDateTime(a.punchTime);
      return dt != null ? AppHelper.formatDate(dt) : null;
    }).whereType<String>().toSet().length;
  }


  /// ---------- RECENT ACTIVITIES (CROSS-DAY) ----------

  static List<AttendanceActivity> recentActivities(
      List<AttendanceActivity> activities, {
        int limit = 10,
      }) {
    final sorted = List<AttendanceActivity>.from(activities)
      ..sort((a, b) {
        final aTime = AppHelper.parseDateTime(a.punchTime);
        final bTime = AppHelper.parseDateTime(b.punchTime);

        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // DESC
      });

    return sorted.take(limit).toList();
  }



  /// ---------- PRIVATE ----------

  static bool _isToday(String? punchTime) {
    final dt = AppHelper.parseDateTime(punchTime);
    if (dt == null) return false;
    return AppHelper.isSameDay(dt, DateTime.now());
  }
}
