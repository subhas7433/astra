import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/widgets/feedback/error_box.dart';

void main() {
  group('ErrorBox', () {
    testWidgets('renders static message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorBox(
              message: 'Static Error',
            ),
          ),
        ),
      );

      expect(find.text('Static Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders reactive message', (WidgetTester tester) async {
      final message = 'Initial Error'.obs;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBox.reactive(
              rxMessage: message,
            ),
          ),
        ),
      );

      expect(find.text('Initial Error'), findsOneWidget);

      // Update message
      message.value = 'Updated Error';
      await tester.pump();

      expect(find.text('Updated Error'), findsOneWidget);
    });

    testWidgets('hides when message is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorBox(
              message: '',
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsNothing);
    });
  });
}
