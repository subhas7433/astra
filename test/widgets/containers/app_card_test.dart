import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/widgets/containers/app_card.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders child content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('handles tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Tap Me'),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders elevated variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard.elevated(
              child: Text('Elevated'),
            ),
          ),
        ),
      );

      expect(find.text('Elevated'), findsOneWidget);
    });
  });
}
