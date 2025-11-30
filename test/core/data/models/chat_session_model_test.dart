import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/chat_session_model.dart';

void main() {
  group('ChatSessionModel', () {
    late ChatSessionModel testSession;
    late DateTime testCreatedAt;
    late DateTime testUpdatedAt;
    late DateTime testLastMessage;

    setUp(() {
      testCreatedAt = DateTime(2024, 1, 1);
      testUpdatedAt = DateTime(2024, 1, 2);
      testLastMessage = DateTime.now().subtract(const Duration(hours: 2));

      testSession = ChatSessionModel(
        id: 'session-123',
        userId: 'user-456',
        astrologerId: 'astro-789',
        lastMessageAt: testLastMessage,
        messageCount: 25,
        isActive: true,
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final session = ChatSessionModel(
          id: 's-1',
          userId: 'u-1',
          astrologerId: 'a-1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(session.id, 's-1');
        expect(session.userId, 'u-1');
        expect(session.astrologerId, 'a-1');
        expect(session.messageCount, 0); // default
        expect(session.isActive, true); // default
        expect(session.lastMessageAt, isNull);
      });

      test('creates instance with all optional fields', () {
        expect(testSession.id, 'session-123');
        expect(testSession.userId, 'user-456');
        expect(testSession.astrologerId, 'astro-789');
        expect(testSession.lastMessageAt, testLastMessage);
        expect(testSession.messageCount, 25);
        expect(testSession.isActive, true);
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-session-999',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-02T00:00:00.000Z',
          'userId': 'user-abc',
          'astrologerId': 'astro-xyz',
          'lastMessageAt': '2024-01-02T10:30:00.000Z',
          'messageCount': 50,
          'isActive': false,
        };

        final session = ChatSessionModel.fromMap(map);

        expect(session.id, 'doc-session-999');
        expect(session.userId, 'user-abc');
        expect(session.astrologerId, 'astro-xyz');
        expect(session.messageCount, 50);
        expect(session.isActive, false);
        expect(session.lastMessageAt, isNotNull);
      });

      test('uses defaults for missing optional fields', () {
        final map = {
          '\$id': 's-min',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-01T00:00:00.000Z',
          'userId': 'u-1',
          'astrologerId': 'a-1',
        };

        final session = ChatSessionModel.fromMap(map);

        expect(session.messageCount, 0);
        expect(session.isActive, true);
        expect(session.lastMessageAt, isNull);
      });

      test('handles null lastMessageAt', () {
        final map = {
          '\$id': 's-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          '\$updatedAt': '2024-01-01T00:00:00.000Z',
          'userId': 'u-1',
          'astrologerId': 'a-1',
          'lastMessageAt': null,
        };

        final session = ChatSessionModel.fromMap(map);
        expect(session.lastMessageAt, isNull);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testSession.toMap();

        expect(map['userId'], 'user-456');
        expect(map['astrologerId'], 'astro-789');
        expect(map['lastMessageAt'], testLastMessage.toIso8601String());
        expect(map['messageCount'], 25);
        expect(map['isActive'], true);
        expect(map['createdAt'], testCreatedAt.toIso8601String());
        expect(map['updatedAt'], testUpdatedAt.toIso8601String());
      });

      test('handles null lastMessageAt', () {
        final session = ChatSessionModel(
          id: 's-1',
          userId: 'u-1',
          astrologerId: 'a-1',
          lastMessageAt: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final map = session.toMap();
        expect(map['lastMessageAt'], isNull);
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-session',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          '\$updatedAt': '2024-06-16T12:00:00.000Z',
          'userId': 'roundtrip-user',
          'astrologerId': 'roundtrip-astro',
          'lastMessageAt': '2024-06-16T11:00:00.000Z',
          'messageCount': 100,
          'isActive': true,
        };

        final s1 = ChatSessionModel.fromMap(originalMap);
        final exportedMap = s1.toMap();

        exportedMap['\$id'] = s1.id;
        exportedMap['\$createdAt'] = s1.createdAt.toIso8601String();
        exportedMap['\$updatedAt'] = s1.updatedAt.toIso8601String();

        final s2 = ChatSessionModel.fromMap(exportedMap);

        expect(s2, equals(s1));
      });
    });

    group('validate', () {
      test('returns success for valid session', () {
        final result = testSession.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final s = testSession.copyWith(id: '');
        final result = s.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Session ID'));
      });

      test('fails when userId is empty', () {
        final s = testSession.copyWith(userId: '');
        final result = s.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('User ID'));
      });

      test('fails when astrologerId is empty', () {
        final s = testSession.copyWith(astrologerId: '');
        final result = s.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Astrologer ID'));
      });

      test('fails when messageCount is negative', () {
        final s = testSession.copyWith(messageCount: -5);
        final result = s.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Message count'));
      });

      test('passes for messageCount of zero', () {
        final s = testSession.copyWith(messageCount: 0);
        final result = s.validate();

        expect(result.isSuccess, isTrue);
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testSession.copyWith(messageCount: 50);

        expect(updated.messageCount, 50);
        expect(updated.id, testSession.id);
        expect(updated.userId, testSession.userId);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testSession.copyWith(
          messageCount: 100,
          isActive: false,
        );

        expect(updated.messageCount, 100);
        expect(updated.isActive, false);
        expect(updated.astrologerId, testSession.astrologerId);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testSession.copyWith();
        expect(copy, equals(testSession));
      });
    });

    group('Computed Properties', () {
      test('hasMessages returns true when messageCount > 0', () {
        expect(testSession.hasMessages, isTrue);

        final empty = testSession.copyWith(messageCount: 0);
        expect(empty.hasMessages, isFalse);
      });

      test('isNew returns true when messageCount is 0', () {
        expect(testSession.isNew, isFalse);

        final newSession = testSession.copyWith(messageCount: 0);
        expect(newSession.isNew, isTrue);
      });

      test('formattedMessageCount formats thousands', () {
        expect(testSession.formattedMessageCount, '25');

        final large = testSession.copyWith(messageCount: 1500);
        expect(large.formattedMessageCount, '1.5k');

        final veryLarge = testSession.copyWith(messageCount: 10500);
        expect(veryLarge.formattedMessageCount, '10.5k');
      });

      test('lastActivityRelative returns null when no last message', () {
        final noMessages = ChatSessionModel(
          id: 's-1',
          userId: 'u-1',
          astrologerId: 'a-1',
          lastMessageAt: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(noMessages.lastActivityRelative, isNull);
      });

      test('lastActivityRelative returns Just now for recent', () {
        final recent = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(seconds: 30)),
        );
        expect(recent.lastActivityRelative, 'Just now');
      });

      test('lastActivityRelative returns minutes ago', () {
        final fiveMin = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );
        expect(fiveMin.lastActivityRelative, '5m ago');
      });

      test('lastActivityRelative returns hours ago', () {
        expect(testSession.lastActivityRelative, '2h ago');
      });

      test('lastActivityRelative returns days ago', () {
        final twoDays = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 2)),
        );
        expect(twoDays.lastActivityRelative, '2d ago');
      });

      test('lastActivityRelative returns weeks ago', () {
        final twoWeeks = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 14)),
        );
        expect(twoWeeks.lastActivityRelative, '2w ago');
      });

      test('lastActivityRelative returns months ago', () {
        final twoMonths = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 60)),
        );
        expect(twoMonths.lastActivityRelative, '2mo ago');
      });

      test('wasActiveToday returns true for today', () {
        final activeToday = testSession.copyWith(
          lastMessageAt: DateTime.now(),
        );
        expect(activeToday.wasActiveToday, isTrue);

        final yesterday = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(yesterday.wasActiveToday, isFalse);
      });

      test('wasActiveToday returns false when no lastMessageAt', () {
        final noMessages = ChatSessionModel(
          id: 's-1',
          userId: 'u-1',
          astrologerId: 'a-1',
          lastMessageAt: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(noMessages.wasActiveToday, isFalse);
      });

      test('wasActiveThisWeek returns true for recent activity', () {
        final recent = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 3)),
        );
        expect(recent.wasActiveThisWeek, isTrue);

        final old = testSession.copyWith(
          lastMessageAt: DateTime.now().subtract(const Duration(days: 10)),
        );
        expect(old.wasActiveThisWeek, isFalse);
      });
    });

    group('Session Operations', () {
      test('recordNewMessage increments count and updates timestamps', () {
        final before = testSession.messageCount;
        final updated = testSession.recordNewMessage();

        expect(updated.messageCount, before + 1);
        expect(updated.lastMessageAt, isNotNull);
        expect(updated.updatedAt.isAfter(testSession.updatedAt), isTrue);
      });

      test('deactivate sets isActive to false', () {
        expect(testSession.isActive, isTrue);

        final deactivated = testSession.deactivate();
        expect(deactivated.isActive, isFalse);
        expect(deactivated.id, testSession.id);
      });

      test('reactivate sets isActive to true', () {
        final inactive = testSession.copyWith(isActive: false);
        expect(inactive.isActive, isFalse);

        final reactivated = inactive.reactivate();
        expect(reactivated.isActive, isTrue);
      });
    });

    group('Equatable', () {
      test('equal sessions are equal', () {
        final date = DateTime(2024, 1, 1);

        final s1 = ChatSessionModel(
          id: 'same-id',
          userId: 'same-user',
          astrologerId: 'same-astro',
          messageCount: 10,
          createdAt: date,
          updatedAt: date,
        );

        final s2 = ChatSessionModel(
          id: 'same-id',
          userId: 'same-user',
          astrologerId: 'same-astro',
          messageCount: 10,
          createdAt: date,
          updatedAt: date,
        );

        expect(s1, equals(s2));
        expect(s1.hashCode, equals(s2.hashCode));
      });

      test('different sessions are not equal', () {
        final s1 = testSession;
        final s2 = testSession.copyWith(id: 'different-id');

        expect(s1, isNot(equals(s2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testSession.toString();

        expect(str, contains('ChatSessionModel'));
        expect(str, contains('session-123'));
        expect(str, contains('user-456'));
        expect(str, contains('astro-789'));
        expect(str, contains('25'));
      });
    });
  });
}
