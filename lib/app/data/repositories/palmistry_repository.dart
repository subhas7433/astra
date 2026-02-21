import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';
import '../models/enums/gender.dart';
import '../models/palm_reading_session_model.dart';
import '../models/palm_reading_message_model.dart';
import '../models/palm_status_model.dart';

class PalmistryRepository {
  final ApiClient _api;

  PalmistryRepository() : _api = Get.find<ApiClient>();

  /// Check palm reading eligibility for a user.
  Future<Result<PalmStatusModel, AppError>> getPalmStatus(
      String userId) async {
    final result =
        await _api.get('/api/v1/palmistry/users/$userId/palm-status');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to get palm status'),
          );
        }
        return Result.success(PalmStatusModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Create a new palm reading session with initial AI analysis.
  Future<Result<CreatePalmReadingResult, AppError>> createReading({
    required String leftPalmImageUrl,
    required String rightPalmImageUrl,
    String tradition = 'vedic',
    String readingLanguage = 'en',
    String? subjectName,
    Gender? subjectGender,
    DateTime? subjectDateOfBirth,
    String? subjectBirthTime,
    String? subjectBirthPlace,
  }) async {
    final data = <String, dynamic>{
      'left_palm_image_url': leftPalmImageUrl,
      'right_palm_image_url': rightPalmImageUrl,
      'tradition': tradition,
      'reading_language': readingLanguage,
    };

    // Only include non-null subject fields
    if (subjectName != null) data['subject_name'] = subjectName;
    if (subjectGender != null) data['subject_gender'] = subjectGender.value;
    if (subjectDateOfBirth != null) {
      data['subject_date_of_birth'] =
          '${subjectDateOfBirth.year}-${subjectDateOfBirth.month.toString().padLeft(2, '0')}-${subjectDateOfBirth.day.toString().padLeft(2, '0')}';
    }
    if (subjectBirthTime != null) data['subject_birth_time'] = subjectBirthTime;
    if (subjectBirthPlace != null) {
      data['subject_birth_place'] = subjectBirthPlace;
    }

    final result = await _api.post(
      '/api/v1/palmistry/readings',
      data: data,
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to create palm reading'),
          );
        }
        final session = PalmReadingSessionModel.fromApiJson(
          data['session'] as Map<String, dynamic>,
        );
        final initialReading = PalmReadingMessageModel.fromApiJson(
          data['initial_reading'] as Map<String, dynamic>,
        );
        return Result.success(CreatePalmReadingResult(
          session: session,
          initialReading: initialReading,
        ));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get a palm reading session with all messages.
  Future<Result<PalmReadingDetailResult, AppError>> getReading(
      String readingId) async {
    final result =
        await _api.get('/api/v1/palmistry/readings/$readingId');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            DocumentNotFoundError(message: 'Palm reading not found'),
          );
        }
        final session = PalmReadingSessionModel.fromApiJson(data);
        final messagesList = data['messages'] as List<dynamic>? ?? [];
        final messages = messagesList
            .map((e) => PalmReadingMessageModel.fromApiJson(
                  e as Map<String, dynamic>,
                ))
            .toList();
        return Result.success(PalmReadingDetailResult(
          session: session,
          messages: messages,
        ));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// List user's palm reading sessions (paginated).
  Future<Result<List<PalmReadingSessionModel>, AppError>> getUserReadings(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await _api.get(
      '/api/v1/palmistry/users/$userId/readings',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final sessions = list
            .map((e) => PalmReadingSessionModel.fromApiJson(
                  e as Map<String, dynamic>,
                ))
            .toList();
        return Result.success(sessions);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Send a follow-up question and receive AI response.
  Future<Result<SendPalmQuestionResult, AppError>> sendQuestion(
    String readingId,
    String content,
  ) async {
    final result = await _api.post(
      '/api/v1/palmistry/readings/$readingId/messages',
      data: {'content': content},
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to send question'),
          );
        }
        final userMessage = PalmReadingMessageModel.fromApiJson(
          data['user_message'] as Map<String, dynamic>,
        );
        final aiResponse = PalmReadingMessageModel.fromApiJson(
          data['ai_response'] as Map<String, dynamic>,
        );
        return Result.success(SendPalmQuestionResult(
          userMessage: userMessage,
          aiResponse: aiResponse,
        ));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get paginated message history for a reading.
  Future<Result<List<PalmReadingMessageModel>, AppError>> getMessages(
    String readingId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final result = await _api.get(
      '/api/v1/palmistry/readings/$readingId/messages',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final messages = list
            .map((e) => PalmReadingMessageModel.fromApiJson(
                  e as Map<String, dynamic>,
                ))
            .toList();
        return Result.success(messages);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Mark a palm reading message as read.
  Future<Result<void, AppError>> markMessageRead(String messageId) async {
    final result =
        await _api.put('/api/v1/palmistry/messages/$messageId/read');
    return result.fold(
      onSuccess: (_) => const Result.success(null),
      onFailure: (error) => Result.failure(error),
    );
  }
}

/// Result wrapper for createReading (returns session + initial AI message).
class CreatePalmReadingResult {
  final PalmReadingSessionModel session;
  final PalmReadingMessageModel initialReading;

  const CreatePalmReadingResult({
    required this.session,
    required this.initialReading,
  });
}

/// Result wrapper for getReading (returns session + all messages).
class PalmReadingDetailResult {
  final PalmReadingSessionModel session;
  final List<PalmReadingMessageModel> messages;

  const PalmReadingDetailResult({
    required this.session,
    required this.messages,
  });
}

/// Result wrapper for sendQuestion (returns user message + AI response).
class SendPalmQuestionResult {
  final PalmReadingMessageModel userMessage;
  final PalmReadingMessageModel aiResponse;

  const SendPalmQuestionResult({
    required this.userMessage,
    required this.aiResponse,
  });
}
