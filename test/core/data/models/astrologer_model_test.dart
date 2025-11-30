import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/astrologer_model.dart';
import 'package:astra/app/data/models/enums/astrologer_category.dart';

void main() {
  group('AstrologerModel', () {
    late AstrologerModel testAstrologer;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime(2024, 1, 1);

      testAstrologer = AstrologerModel(
        id: 'astro-123',
        name: 'Pandit Sharma',
        photoUrl: 'https://example.com/photo.jpg',
        heroImageUrl: 'https://example.com/hero.jpg',
        bio: 'Experienced Vedic astrologer with 20 years of practice.',
        specialization: 'Vedic Astrology',
        expertiseTags: ['Kundli', 'Vastu', 'Numerology'],
        languages: ['Hindi', 'English', 'Sanskrit'],
        rating: 4.5,
        reviewCount: 1500,
        chatCount: 5000,
        category: AstrologerCategory.life,
        isActive: true,
        aiPersonaPrompt: 'You are Pandit Sharma...',
        displayOrder: 1,
        createdAt: testCreatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final astrologer = AstrologerModel(
          id: 'astro-1',
          name: 'Test Astrologer',
          photoUrl: 'https://cdn.com/photo.png',
          bio: 'Test bio for astrologer profile.',
          specialization: 'Numerology',
          category: AstrologerCategory.career,
          createdAt: DateTime.now(),
        );

        expect(astrologer.id, 'astro-1');
        expect(astrologer.name, 'Test Astrologer');
        expect(astrologer.rating, 0.0); // default
        expect(astrologer.reviewCount, 0); // default
        expect(astrologer.chatCount, 0); // default
        expect(astrologer.isActive, true); // default
        expect(astrologer.displayOrder, 0); // default
        expect(astrologer.expertiseTags, isEmpty);
        expect(astrologer.languages, isEmpty);
      });

      test('creates instance with all optional fields', () {
        expect(testAstrologer.id, 'astro-123');
        expect(testAstrologer.name, 'Pandit Sharma');
        expect(testAstrologer.photoUrl, 'https://example.com/photo.jpg');
        expect(testAstrologer.heroImageUrl, 'https://example.com/hero.jpg');
        expect(testAstrologer.rating, 4.5);
        expect(testAstrologer.expertiseTags, ['Kundli', 'Vastu', 'Numerology']);
        expect(testAstrologer.languages, ['Hindi', 'English', 'Sanskrit']);
        expect(testAstrologer.aiPersonaPrompt, 'You are Pandit Sharma...');
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-id-456',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'name': 'Guru Ji',
          'photoUrl': 'https://cdn.com/guru.jpg',
          'heroImageUrl': 'https://cdn.com/hero.jpg',
          'bio': 'Spiritual guide and astrology expert.',
          'specialization': 'Spiritual Guidance',
          'expertiseTags': ['Meditation', 'Yoga', 'Astrology'],
          'languages': ['Hindi', 'English'],
          'rating': 4.8,
          'reviewCount': 2000,
          'chatCount': 8000,
          'category': 'love',
          'isActive': true,
          'aiPersonaPrompt': 'Speak calmly...',
          'displayOrder': 2,
        };

        final astrologer = AstrologerModel.fromMap(map);

        expect(astrologer.id, 'doc-id-456');
        expect(astrologer.name, 'Guru Ji');
        expect(astrologer.rating, 4.8);
        expect(astrologer.category, AstrologerCategory.love);
        expect(astrologer.expertiseTags, ['Meditation', 'Yoga', 'Astrology']);
        expect(astrologer.languages, ['Hindi', 'English']);
      });

      test('uses defaults for missing optional fields', () {
        final map = {
          '\$id': 'astro-min',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'name': 'Minimal',
          'photoUrl': 'https://cdn.com/min.jpg',
          'bio': 'Minimal bio.',
          'specialization': 'Basic',
          'category': 'career',
        };

        final astrologer = AstrologerModel.fromMap(map);

        expect(astrologer.rating, 0.0);
        expect(astrologer.reviewCount, 0);
        expect(astrologer.chatCount, 0);
        expect(astrologer.isActive, true);
        expect(astrologer.displayOrder, 0);
        expect(astrologer.expertiseTags, isEmpty);
        expect(astrologer.languages, isEmpty);
        expect(astrologer.heroImageUrl, isNull);
        expect(astrologer.aiPersonaPrompt, isNull);
      });

      test('defaults category to all for invalid value', () {
        final map = {
          '\$id': 'astro-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'name': 'Test',
          'photoUrl': 'https://cdn.com/t.jpg',
          'bio': 'Test bio text.',
          'specialization': 'Test',
          'category': 'invalid_category',
        };

        final astrologer = AstrologerModel.fromMap(map);
        expect(astrologer.category, AstrologerCategory.all);
      });

      test('handles empty arrays', () {
        final map = {
          '\$id': 'astro-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'name': 'Test',
          'photoUrl': 'https://cdn.com/t.jpg',
          'bio': 'Test bio text.',
          'specialization': 'Test',
          'category': 'life',
          'expertiseTags': [],
          'languages': [],
        };

        final astrologer = AstrologerModel.fromMap(map);
        expect(astrologer.expertiseTags, isEmpty);
        expect(astrologer.languages, isEmpty);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testAstrologer.toMap();

        expect(map['name'], 'Pandit Sharma');
        expect(map['photoUrl'], 'https://example.com/photo.jpg');
        expect(map['heroImageUrl'], 'https://example.com/hero.jpg');
        expect(map['bio'], contains('Vedic astrologer'));
        expect(map['specialization'], 'Vedic Astrology');
        expect(map['expertiseTags'], ['Kundli', 'Vastu', 'Numerology']);
        expect(map['languages'], ['Hindi', 'English', 'Sanskrit']);
        expect(map['rating'], 4.5);
        expect(map['reviewCount'], 1500);
        expect(map['chatCount'], 5000);
        expect(map['category'], 'life');
        expect(map['isActive'], true);
        expect(map['aiPersonaPrompt'], 'You are Pandit Sharma...');
        expect(map['displayOrder'], 1);
        expect(map['createdAt'], testCreatedAt.toIso8601String());
      });

      test('handles null optional fields', () {
        final astrologer = AstrologerModel(
          id: 'astro-1',
          name: 'Test',
          photoUrl: 'https://cdn.com/t.jpg',
          bio: 'Test bio text.',
          specialization: 'Test',
          category: AstrologerCategory.career,
          createdAt: DateTime.now(),
        );

        final map = astrologer.toMap();
        expect(map['heroImageUrl'], isNull);
        expect(map['aiPersonaPrompt'], isNull);
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-astro',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          'name': 'Roundtrip Guru',
          'photoUrl': 'https://cdn.com/roundtrip.jpg',
          'heroImageUrl': 'https://cdn.com/hero.jpg',
          'bio': 'This is a test bio for roundtrip.',
          'specialization': 'Palm Reading',
          'expertiseTags': ['Palm', 'Face Reading'],
          'languages': ['Hindi'],
          'rating': 3.5,
          'reviewCount': 100,
          'chatCount': 500,
          'category': 'love',
          'isActive': false,
          'aiPersonaPrompt': 'You are a palm reader.',
          'displayOrder': 5,
        };

        final astro1 = AstrologerModel.fromMap(originalMap);
        final exportedMap = astro1.toMap();

        // Re-add Appwrite fields for parsing
        exportedMap['\$id'] = astro1.id;
        exportedMap['\$createdAt'] = astro1.createdAt.toIso8601String();

        final astro2 = AstrologerModel.fromMap(exportedMap);

        expect(astro2, equals(astro1));
      });
    });

    group('validate', () {
      test('returns success for valid astrologer', () {
        final result = testAstrologer.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final astro = testAstrologer.copyWith(id: '');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Astrologer ID'));
      });

      test('fails when name is empty', () {
        final astro = testAstrologer.copyWith(name: '');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('name is required'));
      });

      test('fails when name is too short', () {
        final astro = testAstrologer.copyWith(name: 'A');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 2'));
      });

      test('fails when photoUrl is empty', () {
        final astro = testAstrologer.copyWith(photoUrl: '');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('photo URL is required'));
      });

      test('fails for invalid photoUrl format', () {
        final astro = testAstrologer.copyWith(photoUrl: 'not-a-url');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Invalid photo URL'));
      });

      test('fails for invalid heroImageUrl format', () {
        final astro = testAstrologer.copyWith(heroImageUrl: 'bad-url');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Invalid hero image URL'));
      });

      test('passes when heroImageUrl is empty', () {
        final astro = AstrologerModel(
          id: 'astro-1',
          name: 'Test Name',
          photoUrl: 'https://cdn.com/photo.jpg',
          heroImageUrl: '',
          bio: 'This is a valid bio for testing.',
          specialization: 'Testing',
          category: AstrologerCategory.career,
          createdAt: DateTime.now(),
        );
        final result = astro.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when bio is empty', () {
        final astro = testAstrologer.copyWith(bio: '');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('bio is required'));
      });

      test('fails when bio is too short', () {
        final astro = testAstrologer.copyWith(bio: 'Short');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 10'));
      });

      test('fails when specialization is empty', () {
        final astro = testAstrologer.copyWith(specialization: '');
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Specialization'));
      });

      test('fails when rating is negative', () {
        final astro = testAstrologer.copyWith(rating: -1.0);
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('between 0 and 5'));
      });

      test('fails when rating is above 5', () {
        final astro = testAstrologer.copyWith(rating: 5.5);
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('between 0 and 5'));
      });

      test('fails when reviewCount is negative', () {
        final astro = testAstrologer.copyWith(reviewCount: -10);
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Review count'));
      });

      test('fails when chatCount is negative', () {
        final astro = testAstrologer.copyWith(chatCount: -5);
        final result = astro.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Chat count'));
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testAstrologer.copyWith(name: 'New Name');

        expect(updated.name, 'New Name');
        expect(updated.id, testAstrologer.id);
        expect(updated.rating, testAstrologer.rating);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testAstrologer.copyWith(
          rating: 5.0,
          reviewCount: 2000,
          isActive: false,
        );

        expect(updated.rating, 5.0);
        expect(updated.reviewCount, 2000);
        expect(updated.isActive, false);
        expect(updated.name, testAstrologer.name);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testAstrologer.copyWith();
        expect(copy, equals(testAstrologer));
      });
    });

    group('Computed Properties', () {
      test('formattedRating returns decimal string', () {
        expect(testAstrologer.formattedRating, '4.5');

        final perfect = testAstrologer.copyWith(rating: 5.0);
        expect(perfect.formattedRating, '5.0');

        final low = testAstrologer.copyWith(rating: 3.25);
        expect(low.formattedRating, '3.3');
      });

      test('formattedReviewCount formats thousands', () {
        expect(testAstrologer.formattedReviewCount, '1.5k');

        final small = testAstrologer.copyWith(reviewCount: 500);
        expect(small.formattedReviewCount, '500');

        final large = testAstrologer.copyWith(reviewCount: 10500);
        expect(large.formattedReviewCount, '10.5k');
      });

      test('formattedChatCount formats thousands', () {
        expect(testAstrologer.formattedChatCount, '5.0k');

        final small = testAstrologer.copyWith(chatCount: 100);
        expect(small.formattedChatCount, '100');
      });

      test('hasHeroImage works correctly', () {
        expect(testAstrologer.hasHeroImage, isTrue);

        final noHero = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          heroImageUrl: null,
          bio: 'Test bio text here.',
          specialization: 'Test',
          category: AstrologerCategory.all,
          createdAt: DateTime.now(),
        );
        expect(noHero.hasHeroImage, isFalse);

        final emptyHero = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          heroImageUrl: '',
          bio: 'Test bio text here.',
          specialization: 'Test',
          category: AstrologerCategory.all,
          createdAt: DateTime.now(),
        );
        expect(emptyHero.hasHeroImage, isFalse);
      });

      test('hasAiPersona works correctly', () {
        expect(testAstrologer.hasAiPersona, isTrue);

        final noPersona = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          bio: 'Test bio text here.',
          specialization: 'Test',
          category: AstrologerCategory.all,
          aiPersonaPrompt: null,
          createdAt: DateTime.now(),
        );
        expect(noPersona.hasAiPersona, isFalse);
      });

      test('primaryExpertise returns first tag or specialization', () {
        expect(testAstrologer.primaryExpertise, 'Kundli');

        final noTags = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          bio: 'Test bio text here.',
          specialization: 'Vedic Astrology',
          category: AstrologerCategory.all,
          expertiseTags: [],
          createdAt: DateTime.now(),
        );
        expect(noTags.primaryExpertise, 'Vedic Astrology');
      });

      test('expertiseText returns comma-separated tags', () {
        expect(testAstrologer.expertiseText, 'Kundli, Vastu, Numerology');

        final noTags = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          bio: 'Test bio text here.',
          specialization: 'Palmistry',
          category: AstrologerCategory.all,
          expertiseTags: [],
          createdAt: DateTime.now(),
        );
        expect(noTags.expertiseText, 'Palmistry');
      });

      test('languagesText returns comma-separated languages', () {
        expect(testAstrologer.languagesText, 'Hindi, English, Sanskrit');

        final noLang = AstrologerModel(
          id: 'a1',
          name: 'Test',
          photoUrl: 'https://cdn.com/p.jpg',
          bio: 'Test bio text here.',
          specialization: 'Test',
          category: AstrologerCategory.all,
          languages: [],
          createdAt: DateTime.now(),
        );
        expect(noLang.languagesText, 'Hindi, English');
      });

      test('speaksLanguage is case insensitive', () {
        expect(testAstrologer.speaksLanguage('Hindi'), isTrue);
        expect(testAstrologer.speaksLanguage('hindi'), isTrue);
        expect(testAstrologer.speaksLanguage('ENGLISH'), isTrue);
        expect(testAstrologer.speaksLanguage('German'), isFalse);
      });
    });

    group('Equatable', () {
      test('equal astrologers are equal', () {
        final astro1 = AstrologerModel(
          id: 'same-id',
          name: 'Same Name',
          photoUrl: 'https://cdn.com/same.jpg',
          bio: 'Same bio content.',
          specialization: 'Same',
          category: AstrologerCategory.life,
          createdAt: DateTime(2024, 1, 1),
        );

        final astro2 = AstrologerModel(
          id: 'same-id',
          name: 'Same Name',
          photoUrl: 'https://cdn.com/same.jpg',
          bio: 'Same bio content.',
          specialization: 'Same',
          category: AstrologerCategory.life,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(astro1, equals(astro2));
        expect(astro1.hashCode, equals(astro2.hashCode));
      });

      test('different astrologers are not equal', () {
        final astro1 = testAstrologer;
        final astro2 = testAstrologer.copyWith(id: 'different-id');

        expect(astro1, isNot(equals(astro2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testAstrologer.toString();

        expect(str, contains('AstrologerModel'));
        expect(str, contains('astro-123'));
        expect(str, contains('Pandit Sharma'));
        expect(str, contains('Life'));
      });
    });
  });
}
