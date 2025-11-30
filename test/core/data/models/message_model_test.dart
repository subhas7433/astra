import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/data/models/message_model.dart';
import 'package:astra/app/data/models/enums/sender_type.dart';

void main() {
  group('MessageModel', () {
    late MessageModel testMessage;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime.now();

      testMessage = MessageModel(
        id: 'msg-123',
        sessionId: 'session-456',
        senderType: SenderType.user,
        content: 'Hello, can you tell me about my horoscope?',
        isRead: false,
        createdAt: testCreatedAt,
      );
    });

    group('Constructor', () {
      test('creates instance with all required fields', () {
        final message = MessageModel(
          id: 'm-1',
          sessionId: 's-1',
          senderType: SenderType.astrologer,
          content: 'Welcome! How can I help you today?',
          createdAt: DateTime.now(),
        );

        expect(message.id, 'm-1');
        expect(message.sessionId, 's-1');
        expect(message.senderType, SenderType.astrologer);
        expect(message.content, 'Welcome! How can I help you today?');
        expect(message.isRead, false); // default
      });

      test('creates instance with isRead set', () {
        final message = MessageModel(
          id: 'm-1',
          sessionId: 's-1',
          senderType: SenderType.user,
          content: 'Test message',
          isRead: true,
          createdAt: DateTime.now(),
        );

        expect(message.isRead, true);
      });
    });

    group('fromMap', () {
      test('parses Appwrite document with \$id', () {
        final map = {
          '\$id': 'doc-msg-789',
          '\$createdAt': '2024-01-01T10:30:00.000Z',
          'sessionId': 'session-abc',
          'senderType': 'astrologer',
          'content': 'Your Leo horoscope shows positive signs.',
          'isRead': true,
        };

        final message = MessageModel.fromMap(map);

        expect(message.id, 'doc-msg-789');
        expect(message.sessionId, 'session-abc');
        expect(message.senderType, SenderType.astrologer);
        expect(message.content, contains('Leo'));
        expect(message.isRead, true);
      });

      test('uses defaults for missing optional fields', () {
        final map = {
          '\$id': 'm-min',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'sessionId': 's-1',
          'senderType': 'user',
          'content': 'Minimal message.',
        };

        final message = MessageModel.fromMap(map);

        expect(message.isRead, false);
      });

      test('defaults senderType to user for invalid value', () {
        final map = {
          '\$id': 'm-1',
          '\$createdAt': '2024-01-01T00:00:00.000Z',
          'sessionId': 's-1',
          'senderType': 'invalid',
          'content': 'Test.',
        };

        final message = MessageModel.fromMap(map);
        expect(message.senderType, SenderType.user);
      });
    });

    group('toMap', () {
      test('serializes all fields correctly', () {
        final map = testMessage.toMap();

        expect(map['sessionId'], 'session-456');
        expect(map['senderType'], 'user');
        expect(map['content'], 'Hello, can you tell me about my horoscope?');
        expect(map['isRead'], false);
        expect(map['createdAt'], testCreatedAt.toIso8601String());
      });

      test('roundtrip: fromMap -> toMap -> fromMap preserves data', () {
        final originalMap = {
          '\$id': 'roundtrip-msg',
          '\$createdAt': '2024-06-15T10:30:00.000Z',
          'sessionId': 'roundtrip-session',
          'senderType': 'astrologer',
          'content': 'Roundtrip test message content.',
          'isRead': true,
        };

        final m1 = MessageModel.fromMap(originalMap);
        final exportedMap = m1.toMap();

        exportedMap['\$id'] = m1.id;
        exportedMap['\$createdAt'] = m1.createdAt.toIso8601String();

        final m2 = MessageModel.fromMap(exportedMap);

        expect(m2, equals(m1));
      });
    });

    group('validate', () {
      test('returns success for valid message', () {
        final result = testMessage.validate();
        expect(result.isSuccess, isTrue);
      });

      test('fails when id is empty', () {
        final m = testMessage.copyWith(id: '');
        final result = m.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Message ID'));
      });

      test('fails when sessionId is empty', () {
        final m = testMessage.copyWith(sessionId: '');
        final result = m.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Session ID'));
      });

      test('fails when content is empty', () {
        final m = testMessage.copyWith(content: '');
        final result = m.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('Message content'));
      });

      test('fails when content exceeds 5000 characters', () {
        final longContent = 'a' * 5001;
        final m = testMessage.copyWith(content: longContent);
        final result = m.validate();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull?.message, contains('5000'));
      });

      test('passes for content exactly 5000 characters', () {
        final maxContent = 'a' * 5000;
        final m = testMessage.copyWith(content: maxContent);
        final result = m.validate();

        expect(result.isSuccess, isTrue);
      });
    });

    group('copyWith', () {
      test('creates copy with single field changed', () {
        final updated = testMessage.copyWith(isRead: true);

        expect(updated.isRead, true);
        expect(updated.id, testMessage.id);
        expect(updated.content, testMessage.content);
      });

      test('creates copy with multiple fields changed', () {
        final updated = testMessage.copyWith(
          senderType: SenderType.astrologer,
          content: 'Updated content',
          isRead: true,
        );

        expect(updated.senderType, SenderType.astrologer);
        expect(updated.content, 'Updated content');
        expect(updated.isRead, true);
        expect(updated.sessionId, testMessage.sessionId);
      });

      test('creates identical copy when no fields specified', () {
        final copy = testMessage.copyWith();
        expect(copy, equals(testMessage));
      });
    });

    group('Computed Properties', () {
      test('isUserMessage returns true for user sender', () {
        expect(testMessage.isUserMessage, isTrue);
        expect(testMessage.isAstrologerMessage, isFalse);
      });

      test('isAstrologerMessage returns true for astrologer sender', () {
        final astroMsg = testMessage.copyWith(senderType: SenderType.astrologer);
        expect(astroMsg.isAstrologerMessage, isTrue);
        expect(astroMsg.isUserMessage, isFalse);
      });

      test('preview returns short content unchanged', () {
        final shortMsg = testMessage.copyWith(content: 'Short message');
        expect(shortMsg.preview, 'Short message');
      });

      test('preview truncates long content', () {
        final longContent = 'This is a very long message that should be truncated for preview purposes.';
        final longMsg = testMessage.copyWith(content: longContent);

        expect(longMsg.preview.length, 50);
        expect(longMsg.preview, endsWith('...'));
      });

      test('formattedTime formats correctly', () {
        final morning = testMessage.copyWith(
          createdAt: DateTime(2024, 1, 1, 9, 30),
        );
        expect(morning.formattedTime, '9:30 AM');

        final afternoon = testMessage.copyWith(
          createdAt: DateTime(2024, 1, 1, 14, 5),
        );
        expect(afternoon.formattedTime, '2:05 PM');

        final midnight = testMessage.copyWith(
          createdAt: DateTime(2024, 1, 1, 0, 0),
        );
        expect(midnight.formattedTime, '12:00 AM');

        final noon = testMessage.copyWith(
          createdAt: DateTime(2024, 1, 1, 12, 0),
        );
        expect(noon.formattedTime, '12:00 PM');
      });

      test('relativeTime returns Just now for recent messages', () {
        final recent = testMessage.copyWith(
          createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
        );
        expect(recent.relativeTime, 'Just now');
      });

      test('relativeTime returns minutes ago', () {
        final fiveMinAgo = testMessage.copyWith(
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );
        expect(fiveMinAgo.relativeTime, '5m ago');
      });

      test('relativeTime returns hours ago', () {
        final threeHoursAgo = testMessage.copyWith(
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        );
        expect(threeHoursAgo.relativeTime, '3h ago');
      });

      test('relativeTime returns days ago', () {
        final twoDaysAgo = testMessage.copyWith(
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        );
        expect(twoDaysAgo.relativeTime, '2d ago');
      });

      test('isToday returns true for messages sent today', () {
        expect(testMessage.isToday, isTrue);

        final yesterday = testMessage.copyWith(
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(yesterday.isToday, isFalse);
      });

      test('markAsRead creates copy with isRead true', () {
        expect(testMessage.isRead, isFalse);

        final readMessage = testMessage.markAsRead();
        expect(readMessage.isRead, isTrue);
        expect(readMessage.id, testMessage.id);
        expect(readMessage.content, testMessage.content);
      });
    });

    group('Equatable', () {
      test('equal messages are equal', () {
        final date = DateTime(2024, 1, 1, 10, 0);

        final m1 = MessageModel(
          id: 'same-id',
          sessionId: 'same-session',
          senderType: SenderType.user,
          content: 'Same content',
          createdAt: date,
        );

        final m2 = MessageModel(
          id: 'same-id',
          sessionId: 'same-session',
          senderType: SenderType.user,
          content: 'Same content',
          createdAt: date,
        );

        expect(m1, equals(m2));
        expect(m1.hashCode, equals(m2.hashCode));
      });

      test('different messages are not equal', () {
        final m1 = testMessage;
        final m2 = testMessage.copyWith(id: 'different-id');

        expect(m1, isNot(equals(m2)));
      });

      test('messages with different content are not equal', () {
        final m1 = testMessage;
        final m2 = testMessage.copyWith(content: 'Different content');

        expect(m1, isNot(equals(m2)));
      });
    });

    group('toString', () {
      test('returns descriptive string', () {
        final str = testMessage.toString();

        expect(str, contains('MessageModel'));
        expect(str, contains('msg-123'));
        expect(str, contains('You')); // SenderType.user.displayName
      });
    });
  });
}
