import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

/// Palm reading session model for FastAPI 'palm_reading_sessions' table.
class PalmReadingSessionModel extends Equatable {
  final String id;
  final String userId;
  final String leftPalmImageUrl;
  final String rightPalmImageUrl;
  final DateTime? lastMessageAt;
  final int messageCount;
  final bool isFreeReading;
  final String tradition;
  final String readingLanguage;
  final String? subjectName;
  final String? subjectGender;
  final DateTime? subjectDateOfBirth;
  final String? subjectBirthTime;
  final String? subjectBirthPlace;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PalmReadingSessionModel({
    required this.id,
    required this.userId,
    required this.leftPalmImageUrl,
    required this.rightPalmImageUrl,
    this.lastMessageAt,
    this.messageCount = 0,
    this.isFreeReading = false,
    this.tradition = 'vedic',
    this.readingLanguage = 'en',
    this.subjectName,
    this.subjectGender,
    this.subjectDateOfBirth,
    this.subjectBirthTime,
    this.subjectBirthPlace,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create PalmReadingSessionModel from FastAPI REST response (snake_case).
  factory PalmReadingSessionModel.fromApiJson(Map<String, dynamic> json) {
    return PalmReadingSessionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      leftPalmImageUrl: json['left_palm_image_url']?.toString() ?? '',
      rightPalmImageUrl: json['right_palm_image_url']?.toString() ?? '',
      lastMessageAt:
          DateTime.tryParse(json['last_message_at']?.toString() ?? ''),
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      isFreeReading: json['is_free_reading'] as bool? ?? false,
      tradition: json['tradition']?.toString() ?? 'vedic',
      readingLanguage: json['reading_language']?.toString() ?? 'en',
      subjectName: json['subject_name']?.toString(),
      subjectGender: json['subject_gender']?.toString(),
      subjectDateOfBirth: DateTime.tryParse(
          json['subject_date_of_birth']?.toString() ?? ''),
      subjectBirthTime: json['subject_birth_time']?.toString(),
      subjectBirthPlace: json['subject_birth_place']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  /// Validate palm reading session data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Session ID is required'),
      );
    }

    if (userId.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'User ID is required'),
      );
    }

    if (leftPalmImageUrl.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Left palm image URL is required'),
      );
    }

    if (rightPalmImageUrl.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Right palm image URL is required'),
      );
    }

    if (messageCount < 0) {
      return Result.failure(
        const ValidationError(message: 'Message count cannot be negative'),
      );
    }

    return const Result.success(null);
  }

  /// Create a copy with updated fields.
  PalmReadingSessionModel copyWith({
    String? id,
    String? userId,
    String? leftPalmImageUrl,
    String? rightPalmImageUrl,
    DateTime? lastMessageAt,
    int? messageCount,
    bool? isFreeReading,
    String? tradition,
    String? readingLanguage,
    String? subjectName,
    String? subjectGender,
    DateTime? subjectDateOfBirth,
    String? subjectBirthTime,
    String? subjectBirthPlace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PalmReadingSessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      leftPalmImageUrl: leftPalmImageUrl ?? this.leftPalmImageUrl,
      rightPalmImageUrl: rightPalmImageUrl ?? this.rightPalmImageUrl,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
      isFreeReading: isFreeReading ?? this.isFreeReading,
      tradition: tradition ?? this.tradition,
      readingLanguage: readingLanguage ?? this.readingLanguage,
      subjectName: subjectName ?? this.subjectName,
      subjectGender: subjectGender ?? this.subjectGender,
      subjectDateOfBirth: subjectDateOfBirth ?? this.subjectDateOfBirth,
      subjectBirthTime: subjectBirthTime ?? this.subjectBirthTime,
      subjectBirthPlace: subjectBirthPlace ?? this.subjectBirthPlace,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if session has any messages.
  bool get hasMessages => messageCount > 0;

  /// Check if this is a new session (no messages yet).
  bool get isNew => messageCount == 0;

  /// Get formatted message count (e.g., "1.5k").
  String get formattedMessageCount {
    if (messageCount >= 1000) {
      return '${(messageCount / 1000).toStringAsFixed(1)}k';
    }
    return messageCount.toString();
  }

  /// Get relative time since last message.
  String? get lastActivityRelative {
    if (lastMessageAt == null) return null;

    final now = DateTime.now();
    final diff = now.difference(lastMessageAt!);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        leftPalmImageUrl,
        rightPalmImageUrl,
        lastMessageAt,
        messageCount,
        isFreeReading,
        tradition,
        readingLanguage,
        subjectName,
        subjectGender,
        subjectDateOfBirth,
        subjectBirthTime,
        subjectBirthPlace,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() =>
      'PalmReadingSessionModel(id: $id, userId: $userId, messages: $messageCount)';
}
