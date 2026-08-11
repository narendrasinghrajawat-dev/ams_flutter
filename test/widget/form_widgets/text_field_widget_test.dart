import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attedance_management_system/widgets/form_widgets/text_field_widget.dart';

void main() {
  group('TextFieldWidget Widget Tests', () {
    testWidgets('1. Should render label, accept user typing, and update controller text', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldWidget(
              labelText: 'Email Address',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);

      // Enter text into field
      await tester.enterText(find.byType(TextFormField), 'admin@example.com');
      await tester.pump();

      expect(controller.text, 'admin@example.com');
    });

    testWidgets('2. Should display validator error message on invalid input', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFieldWidget(
                labelText: 'Phone',
                controller: controller,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Phone is required';
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger form validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Phone is required'), findsOneWidget);
    });
  });
}
