import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/daily_content_model.dart';
import 'package:astra/app/data/models/enums/content_type.dart';

void main() {
  group('DailyContentModel', () {
    late DailyContentModel testContent;
    late DateTime testValidDate;
    late DateTime testCreatedAt;

    setUp(() {
      testValidDate = DateTime.now();
      testCreatedAt = DateTime(2024, 1, 1);

      testContent = DailyContentModel(
        id: 'content-123',
        type: ContentType.mantra,
        title: 'Om Namah Shivaya',
        titleHi: 'Om Namah Shivaya',
        description:
            'A powerful mantra for inner peace and spiritual awakening.',
        descriptionHi:
            'Aantarik shanti aur adhyaatmik jagran ke liye ek shaktishah mantra.',
        imageUrl: 'https://cdn.com/mantra.jpg',
        audioUrl: 'https://cdn.com/mantra.mp3',
        validDate: testValidDate,
        createdAt: testCreatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final content = DailyContentModel(
          id: 'c-1',
          type: ContentType.deity,
          title: 'Lord Ganesha',
          description: 'Today we worship Lord Ganesha, remover of obstacles.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(content.id, 'c-1');
        expect(content.type, ContentType.deity);
        expect(content.title, 'Lord Ganesha');
        expect(content.titleHi, isNull);
        expect(content.descriptionHi, isNull);
        expect(content.imageUrl, isNull);
        expect(content.audioUrl, isNull);
      });

      test('creates instance with all optional fields', () {
        expect(testContent.id, 'content-123');
        expect(testContent.type, ContentType.mantra);
        expect(testContent.title, 'Om Namah Shivaya');
        expect(testContent.titleHi, 'Om Namah Shivaya');
        expect(testContent.description, contains('inner peace'));
        expect(testContent.descriptionHi, contains('shanti'));
        expect(testContent.imageUrl, 'https://cdn.com/mantra.jpg');
        expect(testContent.audioUrl, 'https://cdn.com/mantra.mp3');
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-content-456',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'type': 'deity',
          'title': 'Lord Hanuman',
          'titleHi': 'Bhagwan Hanuman',
          'description': 'Today we honor the mighty Hanuman.',
          'descriptionHi': 'Aaj hum shaktishah Hanuman ko pranam karte hain.',
          'imageUrl': 'https://cdn.com/hanuman.jpg',
          'audioUrl': 'https://cdn.com/hanuman.mp3',
          'validDate': '2024-01-15T00:00:00.000Z',
        };

        final content = DailyContentModel.fromMap(map);

        expect(content.id, 'doc-content-456');
        expect(content.type, ContentType.deity);
        expect(content.title, 'Lord Hanuman');
        expect(content.titleHi, 'Bhagwan Hanuman');
        expect(content.hasImage, isTrue);
        expect(content.hasAudio, isTrue);
      });

      test('uses defaults for missing optional fields', () {
        final map = {
          '\$id': 'c-min',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'type': 'mantra',
          'title': 'Simple Mantra',
          'description': 'A simple daily mantra.',
          'validDate': '2024-01-01T00:00:00.000Z',
        };

        final content = DailyContentModel.fromMap(map);

        expect(content.titleHi, isNull);
        expect(content.descriptionHi, isNull);
        expect(content.imageUrl, isNull);
        expect(content.audioUrl, isNull);
      });

      test('defaults type to mantra for invalid value', () {
        final map = {
          '\$id': 'c-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'type': 'invalid',
          'title': 'Test',
          'description': 'Test description.',
          'validDate': '2024-01-01T00:00:00.000Z',
        };

        final content = DailyContentModel.fromMap(map);
        expect(content.type, ContentType.mantra);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testContent.toMap();

        expect(map['type'], 'mantra');
        expect(map['title'], 'Om Namah Shivaya');
        expect(map['titleHi'], 'Om Namah Shivaya');
        expect(map['description'], contains('inner peace'));
        expect(map['descriptionHi'], contains('shanti'));
        expect(map['imageUrl'], 'https://cdn.com/mantra.jpg');
        expect(map['audioUrl'], 'https://cdn.com/mantra.mp3');
        expect(map['validDate'], testValidDate.toIso8601String());
        expect(map['createdAt'], testCreatedAt.toIso8601String());
      });

      test('handles null optional fields', () {
        final content = DailyContentModel(
          id: 'c-1',
          type: ContentType.deity,
          title: 'Test',
          description: 'Test description.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        final map = content.toMap();
        expect(map['titleHi'], isNull);
        expect(map['descriptionHi'], isNull);
        expect(map['imageUrl'], isNull);
        expect(map['audioUrl'], isNull);
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-content',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          'type': 'deity',
          'title': 'Roundtrip Deity',
          'titleHi': 'Roundtrip Devta',
          'description': 'Roundtrip description text.',
          'descriptionHi': 'Roundtrip Hindi description.',
          'imageUrl': 'https://cdn.com/rt.jpg',
          'audioUrl': 'https://cdn.com/rt.mp3',
          'validDate': '2024-06-20T00:00:00.000Z',
        };

        final c1 = DailyContentModel.fromMap(originalMap);
        final exportedMap = c1.toMap();

        exportedMap['\$id'] = c1.id;
        exportedMap['\$createdAt'] = c1.createdAt.toIso8601String();

        final c2 = DailyContentModel.fromMap(exportedMap);

        expect(c2, equals(c1));
      });
    });

    group('validate', () {
      test('returns success for valid content', () {
        final result = testContent.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final c = testContent.copyWith(id: '');
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Content ID'));
      });

      test('fails when title is empty', () {
        final c = testContent.copyWith(title: '');
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Title is required'));
      });

      test('fails when title is too short', () {
        final c = testContent.copyWith(title: 'Om');
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 3'));
      });

      test('fails when description is empty', () {
        final c = testContent.copyWith(description: '');
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Description is required'));
      });

      test('fails when description is too short', () {
        final c = testContent.copyWith(description: 'Short');
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 10'));
      });

      test('fails for invalid imageUrl', () {
        final c = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Test Title',
          description: 'Valid description text.',
          imageUrl: 'not-a-url',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('image URL'));
      });

      test('fails for invalid audioUrl', () {
        final c = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Test Title',
          description: 'Valid description text.',
          audioUrl: 'bad-audio-url',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        final result = c.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('audio URL'));
      });

      test('passes when imageUrl is empty', () {
        final c = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Test Title',
          description: 'Valid description text.',
          imageUrl: '',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        final result = c.validate();
        expect(result.isSuccess, isTrue);
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testContent.copyWith(title: 'New Title');

        expect(updated.title, 'New Title');
        expect(updated.id, testContent.id);
        expect(updated.type, testContent.type);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testContent.copyWith(
          type: ContentType.deity,
          title: 'Lord Vishnu',
          description: 'Today we honor Lord Vishnu.',
        );

        expect(updated.type, ContentType.deity);
        expect(updated.title, 'Lord Vishnu');
        expect(updated.description, contains('Vishnu'));
        expect(updated.titleHi, testContent.titleHi);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testContent.copyWith();
        expect(copy, equals(testContent));
      });
    });

    group('Computed Properties', () {
      test('getTitle returns Hindi when available and requested', () {
        expect(testContent.getTitle(hindi: false), 'Om Namah Shivaya');
        expect(testContent.getTitle(hindi: true), 'Om Namah Shivaya');
      });

      test('getTitle falls back to English when Hindi not available', () {
        final noHindi = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'English Title',
          titleHi: null,
          description: 'Description text.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(noHindi.getTitle(hindi: true), 'English Title');
      });

      test('getDescription returns Hindi when available and requested', () {
        expect(testContent.getDescription(hindi: false), contains('inner peace'));
        expect(testContent.getDescription(hindi: true), contains('shanti'));
      });

      test('getDescription falls back to English when Hindi not available', () {
        final noHindi = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          description: 'English description.',
          descriptionHi: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );

        expect(noHindi.getDescription(hindi: true), 'English description.');
      });

      test('isMantra returns true for mantra type', () {
        expect(testContent.isMantra, isTrue);
        expect(testContent.isDeity, isFalse);
      });

      test('isDeity returns true for deity type', () {
        final deity = testContent.copyWith(type: ContentType.deity);
        expect(deity.isDeity, isTrue);
        expect(deity.isMantra, isFalse);
      });

      test('hasHindiTitle works correctly', () {
        expect(testContent.hasHindiTitle, isTrue);

        final noHindi = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          titleHi: null,
          description: 'Description.',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noHindi.hasHindiTitle, isFalse);
      });

      test('hasHindiDescription works correctly', () {
        expect(testContent.hasHindiDescription, isTrue);

        final noHindi = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          description: 'Description.',
          descriptionHi: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noHindi.hasHindiDescription, isFalse);
      });

      test('hasImage works correctly', () {
        expect(testContent.hasImage, isTrue);

        final noImage = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          description: 'Description.',
          imageUrl: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noImage.hasImage, isFalse);

        final emptyImage = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          description: 'Description.',
          imageUrl: '',
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(emptyImage.hasImage, isFalse);
      });

      test('hasAudio works correctly', () {
        expect(testContent.hasAudio, isTrue);

        final noAudio = DailyContentModel(
          id: 'c-1',
          type: ContentType.mantra,
          title: 'Title',
          description: 'Description.',
          audioUrl: null,
          validDate: DateTime.now(),
          createdAt: DateTime.now(),
        );
        expect(noAudio.hasAudio, isFalse);
      });

      test('isForToday returns true for today', () {
        expect(testContent.isForToday, isTrue);

        final yesterday = testContent.copyWith(
          validDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(yesterday.isForToday, isFalse);
      });

      test('isValid returns true for current content', () {
        expect(testContent.isValid, isTrue);

        final expired = testContent.copyWith(
          validDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(expired.isValid, isFalse);
      });

      test('cacheKey generates unique key', () {
        final key = testContent.cacheKey;
        expect(key, startsWith('mantra_'));
      });

      test('typeLabel returns display name', () {
        expect(testContent.typeLabel, "Today's Mantra");

        final deity = testContent.copyWith(type: ContentType.deity);
        expect(deity.typeLabel, "Today's Bhagwan");
      });

      test('typeLabelHindi returns Hindi display name', () {
        expect(testContent.typeLabelHindi, 'Aaj Ka Mantra');

        final deity = testContent.copyWith(type: ContentType.deity);
        expect(deity.typeLabelHindi, 'Aaj Ke Bhagwan');
      });
    });

    group('Equatable', () {
      test('equal contents are equal', () {
        final date = DateTime(2024, 1, 1);

        final c1 = DailyContentModel(
          id: 'same-id',
          type: ContentType.mantra,
          title: 'Same Title',
          description: 'Same description.',
          validDate: date,
          createdAt: date,
        );

        final c2 = DailyContentModel(
          id: 'same-id',
          type: ContentType.mantra,
          title: 'Same Title',
          description: 'Same description.',
          validDate: date,
          createdAt: date,
        );

        expect(c1, equals(c2));
        expect(c1.hashCode, equals(c2.hashCode));
      });

      test('different contents are not equal', () {
        final c1 = testContent;
        final c2 = testContent.copyWith(id: 'different-id');

        expect(c1, isNot(equals(c2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testContent.toString();

        expect(str, contains('DailyContentModel'));
        expect(str, contains('content-123'));
        expect(str, contains("Today's Mantra"));
        expect(str, contains('Om Namah Shivaya'));
      });
    });
  });
}
