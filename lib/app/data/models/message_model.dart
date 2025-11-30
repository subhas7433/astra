import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';
import 'enums/sender_type.dart';

/// Chat message model for Appwrite 'messages' collection.
class MessageModel extends Equatable {
  final String id;
  final String sessionId;
  final SenderType senderType;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.sessionId,
    required this.senderType,
    required this.content,
    this.isRead = false,
    required this.createdAt,
  });

  /// Create MessageModel from Appwrite document map.
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map.appwriteId,
      sessionId: map.getString('sessionId'),
      senderType: SenderType.fromString(map.getString('senderType')) ??
          SenderType.user,
      content: map.getString('content'),
      isRead: map.getBool('isRead', defaultValue: false),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'senderType': senderType.value,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toAppwriteString(),
    };
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

    if (content.length > 5000) {
      return Result.failure(
        const ValidationError(
            message: 'Message content cannot exceed 5000 characters'),
      );
    }

    return const Result.success(null);
  }

  /// Create a copy with updated fields.
  MessageModel copyWith({
    String? id,
    String? sessionId,
    SenderType? senderType,
    String? content,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      senderType: senderType ?? this.senderType,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if this is a user message.
  bool get isUserMessage => senderType.isUser;

  /// Check if this is an astrologer message.
  bool get isAstrologerMessage => senderType.isAstrologer;

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
  MessageModel markAsRead() => copyWith(isRead: true);

  @override
  List<Object?> get props => [
        id,
        sessionId,
        senderType,
        content,
        isRead,
        createdAt,
      ];

  @override
  String toString() =>
      'MessageModel(id: $id, sender: ${senderType.displayName}, preview: $preview)';
}
