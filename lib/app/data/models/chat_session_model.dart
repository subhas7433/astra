import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';

/// Chat session model for Appwrite 'chat_sessions' collection.
class ChatSessionModel extends Equatable {
  final String id;
  final String userId;
  final String astrologerId;
  final DateTime? lastMessageAt;
  final int messageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatSessionModel({
    required this.id,
    required this.userId,
    required this.astrologerId,
    this.lastMessageAt,
    this.messageCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create ChatSessionModel from Appwrite document map.
  factory ChatSessionModel.fromMap(Map<String, dynamic> map) {
    return ChatSessionModel(
      id: map.appwriteId,
      userId: map.getString('userId'),
      astrologerId: map.getString('astrologerId'),
      lastMessageAt: map.getDateTime('lastMessageAt'),
      messageCount: map.getInt('messageCount', defaultValue: 0),
      isActive: map.getBool('isActive', defaultValue: true),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
      updatedAt: map.appwriteUpdatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'astrologerId': astrologerId,
      'lastMessageAt': lastMessageAt?.toAppwriteString(),
      'messageCount': messageCount,
      'isActive': isActive,
      'createdAt': createdAt.toAppwriteString(),
      'updatedAt': updatedAt.toAppwriteString(),
    };
  }

  /// Validate chat session data.
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

    if (astrologerId.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Astrologer ID is required'),
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
  ChatSessionModel copyWith({
    String? id,
    String? userId,
    String? astrologerId,
    DateTime? lastMessageAt,
    int? messageCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      astrologerId: astrologerId ?? this.astrologerId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
      isActive: isActive ?? this.isActive,
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

  /// Check if session was active today.
  bool get wasActiveToday {
    if (lastMessageAt == null) return false;
    final now = DateTime.now();
    return lastMessageAt!.year == now.year &&
        lastMessageAt!.month == now.month &&
        lastMessageAt!.day == now.day;
  }

  /// Check if session was active this week.
  bool get wasActiveThisWeek {
    if (lastMessageAt == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastMessageAt!);
    return diff.inDays < 7;
  }

  /// Update session after a new message.
  ChatSessionModel recordNewMessage() {
    return copyWith(
      lastMessageAt: DateTime.now(),
      messageCount: messageCount + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Deactivate the session.
  ChatSessionModel deactivate() {
    return copyWith(
      isActive: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Reactivate the session.
  ChatSessionModel reactivate() {
    return copyWith(
      isActive: true,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        astrologerId,
        lastMessageAt,
        messageCount,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() =>
      'ChatSessionModel(id: $id, userId: $userId, astrologerId: $astrologerId, messages: $messageCount)';
}
