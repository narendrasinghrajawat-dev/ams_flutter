import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/models/user.dart';

void main() {
  group('AppHelper Unit Tests', () {
    test('1. formatUserName() should capitalize and combine user names properly', () {
      final user = User(
        firstName: 'narendra',
        middleName: 'singh',
        lastName: 'rajawat',
        email: 'test@example.com',
        countryCode: '+91',
        phoneNo: '1234567890',
        username: 'narendra',
        dob: '2000-01-01',
        password: 'pass',
      );

      final formatted = AppHelper.formatUserName(user);
      expect(formatted, 'Narendra Singh Rajawat');
    });

    test('2. isEmptyOrNull() should correctly detect empty, null, and whitespace inputs', () {
      expect(AppHelper.isEmptyOrNull(null), true);
      expect(AppHelper.isEmptyOrNull(''), true);
      expect(AppHelper.isEmptyOrNull('   '), true);
      expect(AppHelper.isEmptyOrNull([]), true);
      expect(AppHelper.isEmptyOrNull({}), true);
      expect(AppHelper.isEmptyOrNull('Valid String'), false);
      expect(AppHelper.isEmptyOrNull(['item1']), false);
    });
  });
}
