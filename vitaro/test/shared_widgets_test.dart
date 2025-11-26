import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitaro/shared_widgets/custom_button.dart';
import 'package:vitaro/shared_widgets/custom_text_field.dart';

void main() {
  group('Shared Widgets Tests', () {
    // Widget Test 1: Verify CustomButton renders text and responds to tap
    testWidgets('CustomButton displays text and triggers callback', (WidgetTester tester) async {
      bool pressed = false;
      const buttonText = 'Test Button';

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Verify text is displayed
      expect(find.text(buttonText), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(CustomButton));
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Verify callback was called
      expect(pressed, isTrue);
    });

    // Widget Test 2: Verify CustomTextField displays hint text
    testWidgets('CustomTextField displays hint text', (WidgetTester tester) async {
      const hintText = 'Enter your email';
      final controller = TextEditingController();

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: hintText,
            ),
          ),
        ),
      );

      // Verify hint text is displayed
      expect(find.text(hintText), findsOneWidget);
    });
  });
}