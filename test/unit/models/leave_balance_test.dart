import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/leave_balance.dart';

void main() {
  group('LeaveBalance Model Unit Tests', () {
    test('1. fromJson and toJson should preserve balance and total counts accurately', () {
      final jsonMap = {
        'id': '1',
        'name': 'Casual/Sick Leave',
        'balance': 5,
        'total': 12,
      };

      final leave = LeaveBalance.fromJson(jsonMap);

      expect(leave.id, '1');
      expect(leave.name, 'Casual/Sick Leave');
      expect(leave.balance, 5);
      expect(leave.total, 12);

      final exportedJson = leave.toJson();
      expect(exportedJson['balance'], 5);
      expect(exportedJson['total'], 12);
    });

    test('2. Calculation of used leaves (total - balance) should be correct', () {
      final leave = LeaveBalance(id: '2', name: 'Annual Leave', balance: 3, total: 10);
      final int used = leave.total - leave.balance;
      final double usageRatio = used / leave.total;

      expect(used, 7);
      expect(usageRatio, 0.7);
    });
  });
}
