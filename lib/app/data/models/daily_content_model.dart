import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';
import 'enums/content_type.dart';

/// Daily content model for Appwrite 'daily_content' collection.
/// Represents both "Today's Mantra" and "Today's Bhagwan" content.
class DailyContentModel extends Equatable {
  final String id;
  final ContentType type;
  final String title;
  final String? titleHi;
  final String description;
  final String? descriptionHi;
  final String? imageUrl;
  final String? audioUrl;
  final DateTime validDate;
  final DateTime createdAt;

  const DailyContentModel({
    required this.id,
    required this.type,
    required this.title,
    this.titleHi,
    required this.description,
    this.descriptionHi,
    this.imageUrl,
    this.audioUrl,
    required this.validDate,
    required this.createdAt,
  });

  /// Create DailyContentModel from Appwrite document map.
  factory DailyContentModel.fromMap(Map<String, dynamic> map) {
    return DailyContentModel(
      id: map.appwriteId,
      type: ContentType.fromString(map.getString('type')) ?? ContentType.mantra,
      title: map.getString('title'),
      titleHi: map.getField<String>('titleHi'),
      description: map.getString('description'),
      descriptionHi: map.getField<String>('descriptionHi'),
      imageUrl: map.getField<String>('imageUrl'),
      audioUrl: map.getField<String>('audioUrl'),
      validDate: map.getDateTime('validDate') ?? DateTime.now(),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'title': title,
      'titleHi': titleHi,
      'description': description,
      'descriptionHi': descriptionHi,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'validDate': validDate.toAppwriteString(),
      'createdAt': createdAt.toAppwriteString(),
    };
  }

  /// Validate daily content data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Content ID is required'),
      );
    }

    if (title.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Title is required'),
      );
    }

    if (title.length < 3) {
      return Result.failure(
        const ValidationError(message: 'Title must be at least 3 characters'),
      );
    }

    if (description.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Description is required'),
      );
    }

    if (description.length < 10) {
      return Result.failure(
        const ValidationError(
            message: 'Description must be at least 10 characters'),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty && !_isValidUrl(imageUrl!)) {
      return Result.failure(
        const ValidationError(message: 'Invalid image URL format'),
      );
    }

    if (audioUrl != null && audioUrl!.isNotEmpty && !_isValidUrl(audioUrl!)) {
      return Result.failure(
        const ValidationError(message: 'Invalid audio URL format'),
      );
    }

    return const Result.success(null);
  }

  /// Basic URL validation.
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  /// Create a copy with updated fields.
  DailyContentModel copyWith({
    String? id,
    ContentType? type,
    String? title,
    String? titleHi,
    String? description,
    String? descriptionHi,
    String? imageUrl,
    String? audioUrl,
    DateTime? validDate,
    DateTime? createdAt,
  }) {
    return DailyContentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      titleHi: titleHi ?? this.titleHi,
      description: description ?? this.description,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      validDate: validDate ?? this.validDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get title based on language preference.
  String getTitle({bool hindi = false}) {
    if (hindi && titleHi != null && titleHi!.isNotEmpty) {
      return titleHi!;
    }
    return title;
  }

  /// Get description based on language preference.
  String getDescription({bool hindi = false}) {
    if (hindi && descriptionHi != null && descriptionHi!.isNotEmpty) {
      return descriptionHi!;
    }
    return description;
  }

  /// Check if this is a mantra content.
  bool get isMantra => type.isMantra;

  /// Check if this is a deity content.
  bool get isDeity => type.isDeity;

  /// Check if Hindi title is available.
  bool get hasHindiTitle => titleHi != null && titleHi!.isNotEmpty;

  /// Check if Hindi description is available.
  bool get hasHindiDescription =>
      descriptionHi != null && descriptionHi!.isNotEmpty;

  /// Check if this content has an image.
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if this content has audio.
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Check if this content is for today.
  bool get isForToday {
    final now = DateTime.now();
    return validDate.year == now.year &&
        validDate.month == now.month &&
        validDate.day == now.day;
  }

  /// Check if this content is still valid (not expired).
  bool get isValid {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return !validDate.isBefore(todayStart);
  }

  /// Get a unique cache key for this content.
  String get cacheKey {
    final dateStr =
        '${validDate.year}${validDate.month.toString().padLeft(2, '0')}${validDate.day.toString().padLeft(2, '0')}';
    return '${type.value}_$dateStr';
  }

  /// Get display label for the content type.
  String get typeLabel => type.displayName;

  /// Get Hindi display label for the content type.
  String get typeLabelHindi => type.hindiName;

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        titleHi,
        description,
        descriptionHi,
        imageUrl,
        audioUrl,
        validDate,
        createdAt,
      ];

  @override
  String toString() =>
      'DailyContentModel(id: $id, type: ${type.displayName}, title: $title)';
}
