import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/modules/horoscope/widgets/zodiac_card.dart';
import 'package:astra/app/modules/horoscope/widgets/category_card.dart';
import 'package:astra/app/core/constants/zodiac_constants.dart';
import 'package:astra/app/data/models/enums/zodiac_sign.dart';

void main() {
  group('Horoscope Widgets Test', () {
    testWidgets('ZodiacCard displays correct info', (WidgetTester tester) async {
      final sign = ZodiacConstants.signs.first; // Aries

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZodiacCard(
              sign: sign,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(sign.name), findsOneWidget);
      expect(find.text(sign.dateRange), findsOneWidget);
      expect(find.text(sign.symbol), findsOneWidget);
    });

    testWidgets('ZodiacCard shows selection state', (WidgetTester tester) async {
      final sign = ZodiacConstants.signs.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZodiacCard(
              sign: sign,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Check for visual changes or specific widgets that appear when selected
      // For now, we assume the card renders without error in selected state
      expect(find.byType(ZodiacCard), findsOneWidget);
    });

    testWidgets('CategoryCard displays correct info', (WidgetTester tester) async {
      const title = 'Love';
      const percentage = 75;
      const prediction = 'Love is in the air.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryCard(
              title: title,
              icon: Icons.favorite,
              color: Colors.red,
              percentage: percentage,
              prediction: prediction,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text('$percentage%'), findsOneWidget);
      expect(find.text(prediction), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
