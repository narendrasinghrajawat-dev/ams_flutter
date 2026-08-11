import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/user.dart';

void main() {
  test('App Smoke Test: User initialization', () {
    final user = User.empty();
    expect(user.firstName, '');
  });
}
