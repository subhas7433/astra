import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'enums/sender_type.dart';

/// Palm reading message model for FastAPI 'palm_reading_messages' table.
class PalmReadingMessageModel extends Equatable {
  final String id;
  final String sessionId;
  final SenderType senderType;
  final String content;
  final bool isRead;
  final bool includedImages;
  final DateTime createdAt;

  const PalmReadingMessageModel({
    required this.id,
    required this.sessionId,
    required this.senderType,
    required this.content,
    this.isRead = false,
    this.includedImages = false,
    required this.createdAt,
  });

  /// Create PalmReadingMessageModel from FastAPI REST response (snake_case).
  /// Backend sends "ai" for AI messages, but SenderType enum uses "astrologer".
  factory PalmReadingMessageModel.fromApiJson(Map<String, dynamic> json) {
    final rawSender = json['sender_type']?.toString();
    final mappedSender = rawSender == 'ai' ? 'astrologer' : rawSender;

    return PalmReadingMessageModel(
      id: json['id']?.toString() ?? '',
      sessionId: json['session_id']?.toString() ?? '',
      senderType: SenderType.fromString(mappedSender) ?? SenderType.user,
      content: json['content']?.toString() ?? '',
      isRead: json['is_read'] as bool? ?? false,
      includedImages: json['included_images'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  /// Validate message data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Message ID is required'),
      );
    }

    if (sessionId.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Session ID is required'),
      );
    }

    if (content.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Message content is required'),
      );
    }

    if (content.length > 4000) {
      return Result.failure(
        const ValidationError(
            message: 'Message content cannot exceed 4000 characters'),
      );
    }

    return const Result.success(null);
  }

  /// Create a copy with updated fields.
  PalmReadingMessageModel copyWith({
    String? id,
    String? sessionId,
    SenderType? senderType,
    String? content,
    bool? isRead,
    bool? includedImages,
    DateTime? createdAt,
  }) {
    return PalmReadingMessageModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      senderType: senderType ?? this.senderType,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      includedImages: includedImages ?? this.includedImages,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if this is a user message.
  bool get isUserMessage => senderType.isUser;

  /// Check if this is an AI message.
  bool get isAiMessage => senderType.isAstrologer;

  /// Get message preview (truncated content).
  String get preview {
    if (content.length <= 50) return content;
    return '${content.substring(0, 47)}...';
  }

  /// Get formatted timestamp for display.
  String get formattedTime {
    final hour = createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Get relative time description (e.g., "Just now", "5m ago").
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formattedTime;
  }

  /// Check if message was sent today.
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  /// Mark message as read.
  PalmReadingMessageModel markAsRead() => copyWith(isRead: true);

  @override
  List<Object?> get props => [
        id,
        sessionId,
        senderType,
        content,
        isRead,
        includedImages,
        createdAt,
      ];

  @override
  String toString() =>
      'PalmReadingMessageModel(id: $id, sender: ${senderType.displayName}, preview: $preview)';
}
