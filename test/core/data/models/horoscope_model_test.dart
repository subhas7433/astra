import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/horoscope_model.dart';
import 'package:astra/app/data/models/enums/zodiac_sign.dart';
import 'package:astra/app/data/models/enums/period_type.dart';
import 'package:astra/app/data/models/enums/horoscope_category.dart';

void main() {
  group('HoroscopeModel', () {
    late HoroscopeModel testHoroscope;
    late DateTime testValidDate;
    late DateTime testCreatedAt;

    setUp(() {
      testValidDate = DateTime.now();
      testCreatedAt = DateTime(2024, 1, 1);

      testHoroscope = HoroscopeModel(
        id: 'horoscope-123',
        zodiacSign: ZodiacSign.leo,
        periodType: PeriodType.daily,
        category: HoroscopeCategory.love,
        predictionText:
            'Today is a great day for love and relationships. Venus is in your favor.',
        predictionTextHi:
            'Aaj prem aur sambandh ke liye ek accha din hai. Shukra aapke paksh mein hai.',
        tipText: 'Wear red for good luck.',
        tipTextHi: 'Achhe bhagya ke liye laal pehne.',
        energyLevel: 75,
        validDate: testValidDate,
        createdAt: testCreatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final horoscope = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.aries,
          periodType: PeriodType.weekly,
          category: HoroscopeCategory.career,
          predictionText:
              'Your career will see significant growth this week.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(horoscope.id, 'h-1');
        expect(horoscope.zodiacSign, ZodiacSign.aries);
        expect(horoscope.periodType, PeriodType.weekly);
        expect(horoscope.category, HoroscopeCategory.career);
        expect(horoscope.energyLevel, 50); // default
        expect(horoscope.predictionTextHi, isNull);
        expect(horoscope.tipText, isNull);
        expect(horoscope.tipTextHi, isNull);
      });

      test('creates instance with all optional fields', () {
        expect(testHoroscope.id, 'horoscope-123');
        expect(testHoroscope.zodiacSign, ZodiacSign.leo);
        expect(testHoroscope.periodType, PeriodType.daily);
        expect(testHoroscope.category, HoroscopeCategory.love);
        expect(testHoroscope.energyLevel, 75);
        expect(testHoroscope.predictionTextHi, isNotNull);
        expect(testHoroscope.tipText, 'Wear red for good luck.');
        expect(testHoroscope.tipTextHi, isNotNull);
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-id-789',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'zodiacSign': 'virgo',
          'periodType': 'monthly',
          'category': 'health',
          'predictionText': 'Focus on your health this month. Take rest.',
          'predictionTextHi': 'Is mahine apni sehat par dhyan de.',
          'tipText': 'Exercise daily.',
          'tipTextHi': 'Rozana vyayam kare.',
          'energyLevel': 60,
          'validDate': '2024-01-15T00:00:00.000Z',
        };

        final horoscope = HoroscopeModel.fromMap(map);

        expect(horoscope.id, 'doc-id-789');
        expect(horoscope.zodiacSign, ZodiacSign.virgo);
        expect(horoscope.periodType, PeriodType.monthly);
        expect(horoscope.category, HoroscopeCategory.health);
        expect(horoscope.energyLevel, 60);
        expect(horoscope.predictionTextHi, contains('sehat'));
      });

      test('uses defaults for missing optional fields', () {
        final map = {
          '\$id': 'h-min',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'zodiacSign': 'taurus',
          'periodType': 'daily',
          'category': 'love',
          'predictionText': 'Minimal prediction text here.',
          'validDate': '2024-01-01T00:00:00.000Z',
        };

        final horoscope = HoroscopeModel.fromMap(map);

        expect(horoscope.energyLevel, 50);
        expect(horoscope.predictionTextHi, isNull);
        expect(horoscope.tipText, isNull);
        expect(horoscope.tipTextHi, isNull);
      });

      test('defaults enums for invalid values', () {
        final map = {
          '\$id': 'h-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'zodiacSign': 'invalid',
          'periodType': 'invalid',
          'category': 'invalid',
          'predictionText': 'Test prediction.',
          'validDate': '2024-01-01T00:00:00.000Z',
        };

        final horoscope = HoroscopeModel.fromMap(map);

        expect(horoscope.zodiacSign, ZodiacSign.aries);
        expect(horoscope.periodType, PeriodType.daily);
        expect(horoscope.category, HoroscopeCategory.love);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testHoroscope.toMap();

        expect(map['zodiacSign'], 'leo');
        expect(map['periodType'], 'daily');
        expect(map['category'], 'love');
        expect(map['predictionText'], contains('great day for love'));
        expect(map['predictionTextHi'], contains('prem'));
        expect(map['tipText'], 'Wear red for good luck.');
        expect(map['tipTextHi'], contains('laal'));
        expect(map['energyLevel'], 75);
        expect(map['validDate'], testValidDate.toIso8601String());
        expect(map['createdAt'], testCreatedAt.toIso8601String());
      });

      test('handles null optional fields', () {
        final horoscope = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.cancer,
          periodType: PeriodType.yearly,
          category: HoroscopeCategory.career,
          predictionText: 'Year prediction text.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        final map = horoscope.toMap();
        expect(map['predictionTextHi'], isNull);
        expect(map['tipText'], isNull);
        expect(map['tipTextHi'], isNull);
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-h',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          'zodiacSign': 'scorpio',
          'periodType': 'weekly',
          'category': 'health',
          'predictionText': 'Roundtrip weekly health prediction.',
          'predictionTextHi': 'Roundtrip Hindi translation.',
          'tipText': 'Drink water.',
          'tipTextHi': 'Paani piyo.',
          'energyLevel': 85,
          'validDate': '2024-06-20T00:00:00.000Z',
        };

        final h1 = HoroscopeModel.fromMap(originalMap);
        final exportedMap = h1.toMap();

        exportedMap['\$id'] = h1.id;
        exportedMap['\$createdAt'] = h1.createdAt.toIso8601String();

        final h2 = HoroscopeModel.fromMap(exportedMap);

        expect(h2, equals(h1));
      });
    });

    group('validate', () {
      test('returns success for valid horoscope', () {
        final result = testHoroscope.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final h = testHoroscope.copyWith(id: '');
        final result = h.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Horoscope ID'));
      });

      test('fails when predictionText is empty', () {
        final h = testHoroscope.copyWith(predictionText: '');
        final result = h.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Prediction text'));
      });

      test('fails when predictionText is too short', () {
        final h = testHoroscope.copyWith(predictionText: 'Too short.');
        final result = h.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 20'));
      });

      test('fails when energyLevel is negative', () {
        final h = testHoroscope.copyWith(energyLevel: -10);
        final result = h.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('between 0 and 100'));
      });

      test('fails when energyLevel is above 100', () {
        final h = testHoroscope.copyWith(energyLevel: 150);
        final result = h.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('between 0 and 100'));
      });

      test('passes for edge case energyLevel values', () {
        final h0 = testHoroscope.copyWith(energyLevel: 0);
        expect(h0.validate().isSuccess, isTrue);

        final h100 = testHoroscope.copyWith(energyLevel: 100);
        expect(h100.validate().isSuccess, isTrue);
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testHoroscope.copyWith(energyLevel: 90);

        expect(updated.energyLevel, 90);
        expect(updated.id, testHoroscope.id);
        expect(updated.zodiacSign, testHoroscope.zodiacSign);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testHoroscope.copyWith(
          zodiacSign: ZodiacSign.pisces,
          periodType: PeriodType.yearly,
          energyLevel: 100,
        );

        expect(updated.zodiacSign, ZodiacSign.pisces);
        expect(updated.periodType, PeriodType.yearly);
        expect(updated.energyLevel, 100);
        expect(updated.category, testHoroscope.category);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testHoroscope.copyWith();
        expect(copy, equals(testHoroscope));
      });
    });

    group('Computed Properties', () {
      test('getPrediction returns Hindi when available and requested', () {
        expect(testHoroscope.getPrediction(hindi: false),
            contains('great day for love'));
        expect(testHoroscope.getPrediction(hindi: true), contains('prem'));
      });

      test('getPrediction falls back to English when Hindi not available', () {
        final noHindi = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.gemini,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'English only prediction.',
          predictionTextHi: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(noHindi.getPrediction(hindi: true), 'English only prediction.');
      });

      test('getTip returns Hindi when available and requested', () {
        expect(testHoroscope.getTip(hindi: false), 'Wear red for good luck.');
        expect(testHoroscope.getTip(hindi: true), contains('laal'));
      });

      test('getTip returns null when no tip available', () {
        final noTip = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Some prediction text here.',
          tipText: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(noTip.getTip(hindi: false), isNull);
        expect(noTip.getTip(hindi: true), isNull);
      });

      test('hasTip works correctly', () {
        expect(testHoroscope.hasTip, isTrue);

        final noTip = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Some prediction text here.',
          tipText: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noTip.hasTip, isFalse);

        final emptyTip = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Some prediction text here.',
          tipText: '',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(emptyTip.hasTip, isFalse);
      });

      test('hasHindiPrediction works correctly', () {
        expect(testHoroscope.hasHindiPrediction, isTrue);

        final noHindi = HoroscopeModel(
          id: 'h-1',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Some prediction text here.',
          predictionTextHi: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noHindi.hasHindiPrediction, isFalse);
      });

      test('energyPercentage formats correctly', () {
        expect(testHoroscope.energyPercentage, '75%');

        final low = testHoroscope.copyWith(energyLevel: 10);
        expect(low.energyPercentage, '10%');

        final max = testHoroscope.copyWith(energyLevel: 100);
        expect(max.energyPercentage, '100%');
      });

      test('energyDescription returns correct level', () {
        expect(testHoroscope.copyWith(energyLevel: 90).energyDescription,
            'High');
        expect(testHoroscope.copyWith(energyLevel: 80).energyDescription,
            'High');
        expect(testHoroscope.copyWith(energyLevel: 70).energyDescription,
            'Good');
        expect(testHoroscope.copyWith(energyLevel: 60).energyDescription,
            'Good');
        expect(testHoroscope.copyWith(energyLevel: 50).energyDescription,
            'Moderate');
        expect(testHoroscope.copyWith(energyLevel: 40).energyDescription,
            'Moderate');
        expect(
            testHoroscope.copyWith(energyLevel: 30).energyDescription, 'Low');
        expect(
            testHoroscope.copyWith(energyLevel: 20).energyDescription, 'Low');
        expect(testHoroscope.copyWith(energyLevel: 10).energyDescription,
            'Very Low');
        expect(testHoroscope.copyWith(energyLevel: 0).energyDescription,
            'Very Low');
      });

      test('isForToday returns true for today', () {
        expect(testHoroscope.isForToday, isTrue);

        final yesterday = testHoroscope.copyWith(
          validDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(yesterday.isForToday, isFalse);
      });

      test('isValid checks validity based on period type', () {
        // Daily horoscope - valid for today
        final dailyToday = testHoroscope.copyWith(
          periodType: PeriodType.daily,
          validDate: DateTime.now(),
        );
        expect(dailyToday.isValid, isTrue);

        // Weekly horoscope - valid within 7 days
        final weeklyRecent = testHoroscope.copyWith(
          periodType: PeriodType.weekly,
          validDate: DateTime.now().subtract(const Duration(days: 5)),
        );
        expect(weeklyRecent.isValid, isTrue);

        // Monthly horoscope - valid within 31 days
        final monthlyRecent = testHoroscope.copyWith(
          periodType: PeriodType.monthly,
          validDate: DateTime.now().subtract(const Duration(days: 20)),
        );
        expect(monthlyRecent.isValid, isTrue);

        // Yearly horoscope - valid within 366 days
        final yearlyRecent = testHoroscope.copyWith(
          periodType: PeriodType.yearly,
          validDate: DateTime.now().subtract(const Duration(days: 300)),
        );
        expect(yearlyRecent.isValid, isTrue);
      });

      test('cacheKey generates unique key', () {
        final key = testHoroscope.cacheKey;
        expect(key, contains('leo'));
        expect(key, contains('daily'));
        expect(key, contains('love'));
      });
    });

    group('Equatable', () {
      test('equal horoscopes are equal', () {
        final date = DateTime(2024, 1, 1);

        final h1 = HoroscopeModel(
          id: 'same-id',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Same prediction text.',
          validDate: date,
          createdAt: date,
        );

        final h2 = HoroscopeModel(
          id: 'same-id',
          zodiacSign: ZodiacSign.leo,
          periodType: PeriodType.daily,
          category: HoroscopeCategory.love,
          predictionText: 'Same prediction text.',
          validDate: date,
          createdAt: date,
        );

        expect(h1, equals(h2));
        expect(h1.hashCode, equals(h2.hashCode));
      });

      test('different horoscopes are not equal', () {
        final h1 = testHoroscope;
        final h2 = testHoroscope.copyWith(id: 'different-id');

        expect(h1, isNot(equals(h2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testHoroscope.toString();

        expect(str, contains('HoroscopeModel'));
        expect(str, contains('horoscope-123'));
        expect(str, contains('Leo'));
        expect(str, contains('Today')); // PeriodType.daily.displayName = 'Today'
      });
    });
  });
}
