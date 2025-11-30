import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/widgets/inputs/password_field.dart';

void main() {
  group('PasswordField', () {
    testWidgets('toggles visibility', (WidgetTester tester) async {
      final visibility = true.obs; // Initially obscured
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordField(
              visibilityState: visibility,
            ),
          ),
        ),
      );

      // Check initial state (obscured)
      final textFieldFinder = find.byType(TextField);
      TextField textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isTrue);

      // Tap toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Check toggled state (visible)
      textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isFalse);
    });
  });
}
