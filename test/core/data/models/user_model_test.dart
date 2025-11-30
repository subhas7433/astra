import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/user_model.dart';
import 'package:astra/app/data/models/enums/gender.dart';
import 'package:astra/app/data/models/enums/zodiac_sign.dart';

void main() {
  group('UserModel', () {
    late UserModel testUser;
    late DateTime testDob;
    late DateTime testCreatedAt;
    late DateTime testUpdatedAt;

    setUp(() {
      testDob = DateTime(1990, 5, 15); // Taurus
      testCreatedAt = DateTime(2024, 1, 1);
      testUpdatedAt = DateTime(2024, 1, 2);

      testUser = UserModel(
        id: 'user-123',
        email: 'test@example.com',
        fullName: 'John Doe',
        gender: Gender.male,
        dateOfBirth: testDob,
        zodiacSign: ZodiacSign.taurus,
        preferredLanguage: 'en',
        profilePhotoUrl: 'https://example.com/photo.jpg',
        fcmToken: 'fcm-token-123',
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final user = UserModel(
          id: 'user-1',
          email: 'user@test.com',
          fullName: 'Test User',
          gender: Gender.female,
          dateOfBirth: DateTime(2000, 1, 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.id, 'user-1');
        expect(user.email, 'user@test.com');
        expect(user.fullName, 'Test User');
        expect(user.gender, Gender.female);
        expect(user.preferredLanguage, 'en'); // default
        expect(user.zodiacSign, isNull);
        expect(user.profilePhotoUrl, isNull);
        expect(user.fcmToken, isNull);
      });

      test('creates instance with all optional fields', () {
        expect(testUser.id, 'user-123');
        expect(testUser.email, 'test@example.com');
        expect(testUser.fullName, 'John Doe');
        expect(testUser.gender, Gender.male);
        expect(testUser.dateOfBirth, testDob);
        expect(testUser.zodiacSign, ZodiacSign.taurus);
        expect(testUser.preferredLanguage, 'en');
        expect(testUser.profilePhotoUrl, 'https://example.com/photo.jpg');
        expect(testUser.fcmToken, 'fcm-token-123');
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-id-123',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'user@example.com',
          'fullName': 'Jane Smith',
          'gender': 'female',
          'dateOfBirth': '1995-03-25T00:00:00.000Z', // Aries
          'zodiacSign': 'aries',
          'preferredLanguage': 'hi',
          'profilePhotoUrl': 'https://cdn.com/jane.jpg',
          'fcmToken': 'token-xyz',
        };

        final user = UserModel.fromMap(map);

        expect(user.id, 'doc-id-123');
        expect(user.email, 'user@example.com');
        expect(user.fullName, 'Jane Smith');
        expect(user.gender, Gender.female);
        expect(user.zodiacSign, ZodiacSign.aries);
        expect(user.preferredLanguage, 'hi');
        expect(user.profilePhotoUrl, 'https://cdn.com/jane.jpg');
        expect(user.fcmToken, 'token-xyz');
      });

      test('parses document with userId fallback', () {
        final map = {
          'userId': 'user-456',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'test@test.com',
          'fullName': 'Test',
          'gender': 'male',
          'dateOfBirth': '2000-01-01T00:00:00.000Z',
        };

        final user = UserModel.fromMap(map);
        expect(user.id, 'user-456');
      });

      test('auto-calculates zodiac sign from DOB when not provided', () {
        final map = {
          '\$id': 'user-789',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'user@test.com',
          'fullName': 'Leo Person',
          'gender': 'other',
          'dateOfBirth': '1990-08-10T00:00:00.000Z', // Leo (Jul 23 - Aug 22)
        };

        final user = UserModel.fromMap(map);
        expect(user.zodiacSign, ZodiacSign.leo);
      });

      test('uses default language when not provided', () {
        final map = {
          '\$id': 'user-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'a@b.com',
          'fullName': 'A B',
          'gender': 'male',
          'dateOfBirth': '2000-01-01T00:00:00.000Z',
        };

        final user = UserModel.fromMap(map);
        expect(user.preferredLanguage, 'en');
      });

      test('handles null optional fields', () {
        final map = {
          '\$id': 'user-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'a@b.com',
          'fullName': 'A B',
          'gender': 'female',
          'dateOfBirth': '2000-01-01T00:00:00.000Z',
          'profilePhotoUrl': null,
          'fcmToken': null,
        };

        final user = UserModel.fromMap(map);
        expect(user.profilePhotoUrl, isNull);
        expect(user.fcmToken, isNull);
      });

      test('defaults gender to other for invalid value', () {
        final map = {
          '\$id': 'user-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'email': 'a@b.com',
          'fullName': 'A B',
          'gender': 'invalid',
          'dateOfBirth': '2000-01-01T00:00:00.000Z',
        };

        final user = UserModel.fromMap(map);
        expect(user.gender, Gender.other);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testUser.toMap();

        expect(map['userId'], 'user-123');
        expect(map['email'], 'test@example.com');
        expect(map['fullName'], 'John Doe');
        expect(map['gender'], 'male');
        expect(map['dateOfBirth'], testDob.toIso8601String());
        expect(map['zodiacSign'], 'taurus');
        expect(map['preferredLanguage'], 'en');
        expect(map['profilePhotoUrl'], 'https://example.com/photo.jpg');
        expect(map['fcmToken'], 'fcm-token-123');
        expect(map['createdAt'], testCreatedAt.toIso8601String());
        expect(map['updatedAt'], testUpdatedAt.toIso8601String());
      });

      test('handles null zodiacSign', () {
        final user = UserModel(
          id: 'user-1',
          email: 'a@b.com',
          fullName: 'Test',
          gender: Gender.male,
          dateOfBirth: DateTime(2000, 1, 1),
          zodiacSign: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final map = user.toMap();
        expect(map['zodiacSign'], isNull);
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-user',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          '\$updatedAt': '2024-06-16T12:00:00.000Z',
          'email': 'roundtrip@test.com',
          'fullName': 'Roundtrip User',
          'gender': 'female',
          'dateOfBirth': '1985-12-20T00:00:00.000Z',
          'zodiacSign': 'sagittarius',
          'preferredLanguage': 'hi',
          'profilePhotoUrl': 'https://cdn.com/photo.png',
          'fcmToken': 'token-abc',
        };

        final user1 = UserModel.fromMap(originalMap);
        final exportedMap = user1.toMap();

        // Re-add Appwrite fields for parsing
        exportedMap['\$id'] = user1.id;
        exportedMap['\$createdAt'] = user1.createdAt.toIso8601String();
        exportedMap['\$updatedAt'] = user1.updatedAt.toIso8601String();

        final user2 = UserModel.fromMap(exportedMap);

        expect(user2, equals(user1));
      });
    });

    group('validate', () {
      test('returns success for valid user', () {
        final result = testUser.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final user = testUser.copyWith(id: '');
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('User ID'));
      });

      test('fails when email is empty', () {
        final user = testUser.copyWith(email: '');
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Email'));
      });

      test('fails for invalid email format', () {
        final invalidEmails = [
          'invalid',
          'no@domain',
          '@nodomain.com',
          'spaces in@email.com',
          'missing@.com',
        ];

        for (final email in invalidEmails) {
          final user = testUser.copyWith(email: email);
          final result = user.validate();

          expect(result.isFailure, isTrue,
              reason: 'Email "$email" should be invalid');
        }
      });

      test('passes for valid email formats', () {
        final validEmails = [
          'simple@example.com',
          'user.name@domain.org',
          'user+tag@example.co.uk',
          'test123@subdomain.domain.com',
        ];

        for (final email in validEmails) {
          final user = testUser.copyWith(email: email);
          final result = user.validate();

          expect(result.isSuccess, isTrue,
              reason: 'Email "$email" should be valid');
        }
      });

      test('fails when fullName is empty', () {
        final user = testUser.copyWith(fullName: '');
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Full name'));
      });

      test('fails when fullName is too short', () {
        final user = testUser.copyWith(fullName: 'A');
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('at least 2'));
      });

      test('fails when dateOfBirth is in the future', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final user = testUser.copyWith(dateOfBirth: futureDate);
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('past'));
      });

      test('fails for unreasonable age (>150 years)', () {
        final ancientDate = DateTime(1800, 1, 1);
        final user = testUser.copyWith(dateOfBirth: ancientDate);
        final result = user.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Invalid date'));
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testUser.copyWith(fullName: 'New Name');

        expect(updated.fullName, 'New Name');
        expect(updated.id, testUser.id);
        expect(updated.email, testUser.email);
        expect(updated.gender, testUser.gender);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testUser.copyWith(
          email: 'new@email.com',
          preferredLanguage: 'hi',
          profilePhotoUrl: 'https://new.url/photo.jpg',
        );

        expect(updated.email, 'new@email.com');
        expect(updated.preferredLanguage, 'hi');
        expect(updated.profilePhotoUrl, 'https://new.url/photo.jpg');
        expect(updated.fullName, testUser.fullName);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testUser.copyWith();
        expect(copy, equals(testUser));
      });

      test('allows setting nullable fields', () {
        final updated = testUser.copyWith(
          zodiacSign: ZodiacSign.virgo,
          fcmToken: 'new-token',
        );

        expect(updated.zodiacSign, ZodiacSign.virgo);
        expect(updated.fcmToken, 'new-token');
      });
    });

    group('Computed Properties', () {
      test('age calculates correctly', () {
        final now = DateTime.now();
        final dob = DateTime(now.year - 25, now.month, now.day);
        final user = testUser.copyWith(dateOfBirth: dob);

        expect(user.age, 25);
      });

      test('age accounts for birthday not yet occurred', () {
        final now = DateTime.now();
        // Birthday is next month
        final dob = DateTime(now.year - 25, now.month + 1, now.day);
        final user = testUser.copyWith(dateOfBirth: dob);

        expect(user.age, 24);
      });

      test('prefersHindi returns true for hindi language', () {
        final hindiUser = testUser.copyWith(preferredLanguage: 'hi');
        expect(hindiUser.prefersHindi, isTrue);

        final englishUser = testUser.copyWith(preferredLanguage: 'en');
        expect(englishUser.prefersHindi, isFalse);
      });

      test('hasProfilePhoto works correctly', () {
        expect(testUser.hasProfilePhoto, isTrue);

        // Create a user without profile photo
        final noPhoto = UserModel(
          id: 'user-1',
          email: 'test@test.com',
          fullName: 'Test',
          gender: Gender.male,
          dateOfBirth: DateTime(2000, 1, 1),
          profilePhotoUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(noPhoto.hasProfilePhoto, isFalse);

        // Empty string should also be false
        final emptyPhoto = UserModel(
          id: 'user-1',
          email: 'test@test.com',
          fullName: 'Test',
          gender: Gender.male,
          dateOfBirth: DateTime(2000, 1, 1),
          profilePhotoUrl: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(emptyPhoto.hasProfilePhoto, isFalse);
      });

      test('firstName extracts first word', () {
        expect(testUser.firstName, 'John');

        final singleName = testUser.copyWith(fullName: 'SingleName');
        expect(singleName.firstName, 'SingleName');
      });

      test('initials work for various name formats', () {
        expect(testUser.initials, 'JD');

        final singleName = testUser.copyWith(fullName: 'John');
        expect(singleName.initials, 'J');

        final threeParts = testUser.copyWith(fullName: 'John William Doe');
        expect(threeParts.initials, 'JD');

        final empty = testUser.copyWith(fullName: '');
        expect(empty.initials, '?');
      });
    });

    group('Equatable', () {
      test('equal users are equal', () {
        final user1 = UserModel(
          id: 'same-id',
          email: 'same@email.com',
          fullName: 'Same Name',
          gender: Gender.male,
          dateOfBirth: DateTime(2000, 1, 1),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        final user2 = UserModel(
          id: 'same-id',
          email: 'same@email.com',
          fullName: 'Same Name',
          gender: Gender.male,
          dateOfBirth: DateTime(2000, 1, 1),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('different users are not equal', () {
        final user1 = testUser;
        final user2 = testUser.copyWith(id: 'different-id');

        expect(user1, isNot(equals(user2)));
      });

      test('users with different emails are not equal', () {
        final user1 = testUser;
        final user2 = testUser.copyWith(email: 'different@email.com');

        expect(user1, isNot(equals(user2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testUser.toString();

        expect(str, contains('UserModel'));
        expect(str, contains('user-123'));
        expect(str, contains('test@example.com'));
        expect(str, contains('John Doe'));
      });
    });
  });
}
