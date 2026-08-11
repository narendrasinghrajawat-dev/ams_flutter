import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/user.dart';

void main() {
  group('User Model Unit Tests', () {
    test('1. User.empty() should initialize all required fields safely with empty values', () {
      final user = User.empty();

      expect(user.firstName, '');
      expect(user.lastName, '');
      expect(user.email, '');
      expect(user.phoneNo, '');
      expect(user.username, '');
      expect(user.key, '');
    });

    test('2. User.fromJson() should correctly parse JSON map into User model', () {
      final jsonMap = {
        '_key': 'usr_123',
        '_rev': 'rev_456',
        'id': '1',
        'firstName': 'Narendra',
        'middleName': 'Singh',
        'lastName': 'Rajawat',
        'email': 'narendra@example.com',
        'countryCode': '+91',
        'phoneNo': '9876543210',
        'username': 'narendra_dev',
        'dob': '2000-01-01',
        'genderId': '1',
        'roleId': '2',
        'password': 'hashed_pass_123',
        'employeeId': 'EMP0001',
      };

      final user = User.fromJson(jsonMap);

      expect(user.key, 'usr_123');
      expect(user.firstName, 'Narendra');
      expect(user.middleName, 'Singh');
      expect(user.lastName, 'Rajawat');
      expect(user.email, 'narendra@example.com');
      expect(user.employeeId, 'EMP0001');
      expect(user.roleId, '2');
    });
  });
}
