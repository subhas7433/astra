import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';
import '../models/chat_session_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ApiClient _api;

  ChatRepository() : _api = Get.find<ApiClient>();

  /// Create or get existing session (idempotent on backend).
  /// Returns session ID.
  Future<Result<String, AppError>> createSession(String astrologerId, {String? userId}) async {
    final data = <String, dynamic>{'astrologer_id': astrologerId};
    if (userId != null) {
      data['user_id'] = userId;
    }
    final result = await _api.post(
      '/api/v1/chat/sessions',
      data: data,
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to create session'),
          );
        }
        final id = data['id']?.toString() ?? '';
        return Result.success(id);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get messages for a session
  Future<Result<List<MessageModel>, AppError>> getMessages(
      String sessionId) async {
    final result = await _api.get('/api/v1/chat/sessions/$sessionId/messages');
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final messages = list
            .map((e) => MessageModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(messages);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Send a message and get AI response back.
  /// Returns both user message and AI response.
  Future<Result<SendMessageResult, AppError>> sendMessage(
    String sessionId,
    String astrologerId,
    String content,
  ) async {
    final result = await _api.post(
      '/api/v1/chat/message',
      data: {
        'astrologer_id': astrologerId,
        'session_id': sessionId,
        'content': content,
      },
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to send message'),
          );
        }
        final userMsg =
            MessageModel.fromApiJson(data['user_message'] as Map<String, dynamic>);
        final aiMsg =
            MessageModel.fromApiJson(data['ai_response'] as Map<String, dynamic>);
        return Result.success(SendMessageResult(
          userMessage: userMsg,
          aiResponse: aiMsg,
        ));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get a greeting from the AI for a new session.
  Future<Result<GreetingResult, AppError>> getGreeting(
    String sessionId,
    String astrologerId,
  ) async {
    final result = await _api.post(
      '/api/v1/chat/sessions/$sessionId/greeting',
      data: {'astrologer_id': astrologerId},
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to get greeting'),
          );
        }
        final greeting =
            MessageModel.fromApiJson(data['greeting'] as Map<String, dynamic>);
        return Result.success(GreetingResult(greeting: greeting));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Mark messages as read
  Future<Result<void, AppError>> markMessagesRead(String sessionId) async {
    final result =
        await _api.put('/api/v1/chat/sessions/$sessionId/mark-read');
    return result.fold(
      onSuccess: (_) => const Result.success(null),
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get user's chat sessions
  Future<Result<List<ChatSessionModel>, AppError>> getUserSessions() async {
    final result = await _api.get('/api/v1/chat/sessions');
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final sessions = list
            .map((e) =>
                ChatSessionModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(sessions);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Legacy no-op: saveMessage is handled server-side now.
  Future<Result<void, AppError>> saveMessage(
      String sessionId, MessageModel message) async {
    return const Result.success(null);
  }
}

class SendMessageResult {
  final MessageModel userMessage;
  final MessageModel aiResponse;
  const SendMessageResult({required this.userMessage, required this.aiResponse});
}

class GreetingResult {
  final MessageModel greeting;
  const GreetingResult({required this.greeting});
}
