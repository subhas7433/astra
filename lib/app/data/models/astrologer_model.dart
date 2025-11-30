import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';
import 'enums/astrologer_category.dart';

/// AI Astrologer persona model for Appwrite 'astrologers' collection.
class AstrologerModel extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final String? heroImageUrl;
  final String bio;
  final String specialization;
  final List<String> expertiseTags;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final int chatCount;
  final AstrologerCategory category;
  final bool isActive;
  final String? aiPersonaPrompt;
  final int displayOrder;
  final DateTime createdAt;

  const AstrologerModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.heroImageUrl,
    required this.bio,
    required this.specialization,
    this.expertiseTags = const [],
    this.languages = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.chatCount = 0,
    required this.category,
    this.isActive = true,
    this.aiPersonaPrompt,
    this.displayOrder = 0,
    required this.createdAt,
  });

  /// Create AstrologerModel from Appwrite document map.
  factory AstrologerModel.fromMap(Map<String, dynamic> map) {
    return AstrologerModel(
      id: map.appwriteId,
      name: map.getString('name'),
      photoUrl: map.getString('photoUrl'),
      heroImageUrl: map.getField<String>('heroImageUrl'),
      bio: map.getString('bio'),
      specialization: map.getString('specialization'),
      expertiseTags: map.getStringList('expertiseTags'),
      languages: map.getStringList('languages'),
      rating: map.getDouble('rating', defaultValue: 0.0),
      reviewCount: map.getInt('reviewCount', defaultValue: 0),
      chatCount: map.getInt('chatCount', defaultValue: 0),
      category: AstrologerCategory.fromString(map.getString('category')) ??
          AstrologerCategory.all,
      isActive: map.getBool('isActive', defaultValue: true),
      aiPersonaPrompt: map.getField<String>('aiPersonaPrompt'),
      displayOrder: map.getInt('displayOrder', defaultValue: 0),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'heroImageUrl': heroImageUrl,
      'bio': bio,
      'specialization': specialization,
      'expertiseTags': expertiseTags,
      'languages': languages,
      'rating': rating,
      'reviewCount': reviewCount,
      'chatCount': chatCount,
      'category': category.value,
      'isActive': isActive,
      'aiPersonaPrompt': aiPersonaPrompt,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toAppwriteString(),
    };
  }

  /// Validate astrologer data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Astrologer ID is required'),
      );
    }

    if (name.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Astrologer name is required'),
      );
    }

    if (name.length < 2) {
      return Result.failure(
        const ValidationError(
            message: 'Astrologer name must be at least 2 characters'),
      );
    }

    if (photoUrl.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Astrologer photo URL is required'),
      );
    }

    if (!_isValidUrl(photoUrl)) {
      return Result.failure(
        const ValidationError(message: 'Invalid photo URL format'),
      );
    }

    if (heroImageUrl != null &&
        heroImageUrl!.isNotEmpty &&
        !_isValidUrl(heroImageUrl!)) {
      return Result.failure(
        const ValidationError(message: 'Invalid hero image URL format'),
      );
    }

    if (bio.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Astrologer bio is required'),
      );
    }

    if (bio.length < 10) {
      return Result.failure(
        const ValidationError(
            message: 'Bio must be at least 10 characters'),
      );
    }

    if (specialization.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Specialization is required'),
      );
    }

    if (rating < 0 || rating > 5) {
      return Result.failure(
        const ValidationError(message: 'Rating must be between 0 and 5'),
      );
    }

    if (reviewCount < 0) {
      return Result.failure(
        const ValidationError(message: 'Review count cannot be negative'),
      );
    }

    if (chatCount < 0) {
      return Result.failure(
        const ValidationError(message: 'Chat count cannot be negative'),
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
  AstrologerModel copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? heroImageUrl,
    String? bio,
    String? specialization,
    List<String>? expertiseTags,
    List<String>? languages,
    double? rating,
    int? reviewCount,
    int? chatCount,
    AstrologerCategory? category,
    bool? isActive,
    String? aiPersonaPrompt,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return AstrologerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      bio: bio ?? this.bio,
      specialization: specialization ?? this.specialization,
      expertiseTags: expertiseTags ?? this.expertiseTags,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      chatCount: chatCount ?? this.chatCount,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      aiPersonaPrompt: aiPersonaPrompt ?? this.aiPersonaPrompt,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get formatted rating string (e.g., "4.5").
  String get formattedRating => rating.toStringAsFixed(1);

  /// Get formatted review count (e.g., "1.2k").
  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k';
    }
    return reviewCount.toString();
  }

  /// Get formatted chat count (e.g., "5.3k").
  String get formattedChatCount {
    if (chatCount >= 1000) {
      return '${(chatCount / 1000).toStringAsFixed(1)}k';
    }
    return chatCount.toString();
  }

  /// Check if astrologer has hero image.
  bool get hasHeroImage => heroImageUrl != null && heroImageUrl!.isNotEmpty;

  /// Check if astrologer has AI persona.
  bool get hasAiPersona =>
      aiPersonaPrompt != null && aiPersonaPrompt!.isNotEmpty;

  /// Get first expertise tag or specialization.
  String get primaryExpertise =>
      expertiseTags.isNotEmpty ? expertiseTags.first : specialization;

  /// Get all expertise as comma-separated string.
  String get expertiseText => expertiseTags.isNotEmpty
      ? expertiseTags.join(', ')
      : specialization;

  /// Get languages as comma-separated string.
  String get languagesText =>
      languages.isNotEmpty ? languages.join(', ') : 'Hindi, English';

  /// Check if astrologer speaks a specific language.
  bool speaksLanguage(String language) {
    return languages
        .map((l) => l.toLowerCase())
        .contains(language.toLowerCase());
  }

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        heroImageUrl,
        bio,
        specialization,
        expertiseTags,
        languages,
        rating,
        reviewCount,
        chatCount,
        category,
        isActive,
        aiPersonaPrompt,
        displayOrder,
        createdAt,
      ];

  @override
  String toString() =>
      'AstrologerModel(id: $id, name: $name, category: ${category.displayName})';
}
