import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/attendance_activity.dart';
import 'package:attedance_management_system/modules/user/helper/user_home_helper.dart';

void main() {
  group('UserHomeHelper Unit Tests', () {
    test('1. todayCheckIn & todayCheckOut should correctly filter punch activities for today', () {
      final now = DateTime.now();
      final checkInTime = DateTime(now.year, now.month, now.day, 9, 0).toIso8601String();
      final checkOutTime = DateTime(now.year, now.month, now.day, 18, 0).toIso8601String();

      final activities = [
        AttendanceActivity(
          punchType: '1', // Check In
          punchTime: checkInTime,
          punchDate: checkInTime,
          userKey: 'user_1',
        ),
        AttendanceActivity(
          punchType: '2', // Check Out
          punchTime: checkOutTime,
          punchDate: checkOutTime,
          userKey: 'user_1',
        ),
      ];

      final inAct = UserHomeHelper.todayCheckIn(activities);
      final outAct = UserHomeHelper.todayCheckOut(activities);

      expect(inAct, isNotNull);
      expect(inAct?.punchType, '1');
      expect(outAct, isNotNull);
      expect(outAct?.punchType, '2');
    });

    test('2. elapsedToday should accurately calculate hours and minutes difference', () {
      final now = DateTime.now();
      final checkInTime = DateTime(now.year, now.month, now.day, 9, 30).toIso8601String();
      final checkOutTime = DateTime(now.year, now.month, now.day, 18, 0).toIso8601String();

      final inAct = AttendanceActivity(punchType: '1', punchTime: checkInTime, userKey: 'u1');
      final outAct = AttendanceActivity(punchType: '2', punchTime: checkOutTime, userKey: 'u1');

      final duration = UserHomeHelper.elapsedToday(inAct, outAct);

      expect(duration.inHours, 8);
      expect(duration.inMinutes, 8 * 60 + 30); // 8 hours 30 minutes
    });
  });
}
