import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';

void main() {
  group('CommonCardWidget Widget Tests', () {
    testWidgets('1. Should render child content inside the card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonCardWidget(
              child: const Text('AMS Attendance Summary'),
            ),
          ),
        ),
      );

      expect(find.text('AMS Attendance Summary'), findsOneWidget);
    });

    testWidgets('2. Should render custom child elements like icons and texts together', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonCardWidget(
              child: const Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('Admin User Profile'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('Admin User Profile'), findsOneWidget);
    });
  });
}
