import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/segmented_tabs.dart';

void main() {
  group('SegmentedTabs Widget Tests', () {
    testWidgets('1. Should render all provided tab labels on screen', (WidgetTester tester) async {
      const tabs = ['Approved', 'Pending', 'Rejected', 'Cancelled'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SegmentedTabs(
              labels: tabs,
              selectedIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      for (final label in tabs) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('2. Should trigger onTap callback with the correct index when clicked', (WidgetTester tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SegmentedTabs(
              labels: const ['Approved', 'Pending', 'Rejected'],
              selectedIndex: 0,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Tap on 'Pending' (index 1)
      await tester.tap(find.text('Pending'));
      await tester.pump();

      expect(tappedIndex, 1);
    });
  });
}
