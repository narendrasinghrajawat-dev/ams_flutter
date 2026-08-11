import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/models/leave_balance.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/leave_balance_card.dart';

void main() {
  group('LeaveBalanceCard Widget Tests', () {
    testWidgets('1. Should render leave title, total, available and used numbers', (WidgetTester tester) async {
      final balance = LeaveBalance(
        id: '1',
        name: 'Casual/Sick Leave',
        balance: 4,
        total: 10,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeaveBalanceCard(balance: balance),
          ),
        ),
      );

      expect(find.text('Casual/Sick Leave'), findsOneWidget);
      expect(find.text('10'), findsOneWidget); // Total
      expect(find.text('4'), findsOneWidget);  // Available
      expect(find.text('6'), findsOneWidget);  // Used = 10 - 4 = 6
    });
  });
}
