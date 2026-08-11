import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/masterData.dart';

void main() {
  group('MasterData Model Unit Tests', () {
    test('1. fromJson should correctly parse office location and radius parameters', () {
      final jsonMap = {
        'officeLat': '26.9124',
        'officeLong': '75.7873',
        'officeRadius': 100,
        'maxWFHInSingleMonth': 10,
        'leaveStatus': [
          {'id': '1', 'name': 'Pending'},
          {'id': '2', 'name': 'Approved'},
        ],
        'role': [
          {'id': '1', 'name': 'Employee'},
          {'id': '2', 'name': 'Admin'},
        ],
        'gender': [
          {'id': '1', 'name': 'Male'},
          {'id': '2', 'name': 'Female'},
        ],
        'leaveDurationsType': [],
        'halfDayShiftType': [],
        'leaveType': [],
      };

      final master = MasterData.fromJson(jsonMap);

      expect(master.officeLat, '26.9124');
      expect(master.officeLong, '75.7873');
      expect(master.officeRadius, 100);
      expect(master.maxWFHInSingleMonth, 10);
      expect(master.leaveStatus.length, 2);
      expect(master.role.first.name, 'Employee');
      expect(master.gender.last.name, 'Female');
    });
  });
}
