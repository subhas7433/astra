import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';
import 'enums/gender.dart';
import 'enums/zodiac_sign.dart';

/// User profile model for Appwrite 'users' collection.
class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final Gender gender;
  final DateTime dateOfBirth;
  final ZodiacSign? zodiacSign;
  final String preferredLanguage;
  final String? profilePhotoUrl;
  final String? fcmToken;
  final String? birthTime;
  final String? birthPlace;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    this.zodiacSign,
    this.preferredLanguage = 'en',
    this.profilePhotoUrl,
    this.fcmToken,
    this.birthTime,
    this.birthPlace,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserModel from Appwrite document map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final dob = map.getDateTime('dateOfBirth') ?? DateTime.now();

    // Auto-calculate zodiac sign if not provided
    ZodiacSign? zodiac = ZodiacSign.fromString(map.getString('zodiacSign'));
    zodiac ??= ZodiacSign.fromDate(dob);

    return UserModel(
      id: map.appwriteId.isNotEmpty ? map.appwriteId : map.getString('userId'),
      email: map.getString('email'),
      fullName: map.getString('fullName'),
      gender: Gender.fromString(map.getString('gender')) ?? Gender.other,
      dateOfBirth: dob,
      zodiacSign: zodiac,
      preferredLanguage: map.getString('preferredLanguage', defaultValue: 'en'),
      profilePhotoUrl: map.getField<String>('profilePhotoUrl'),
      fcmToken: map.getField<String>('fcmToken'),
      birthTime: map.getField<String>('birthTime'),
      birthPlace: map.getField<String>('birthPlace'),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
      updatedAt: map.appwriteUpdatedAt ?? DateTime.now(),
    );
  }

  /// Create UserModel from FastAPI REST response (snake_case).
  factory UserModel.fromApiJson(Map<String, dynamic> json) {
    final dob = DateTime.tryParse(json['date_of_birth']?.toString() ?? '') ??
        DateTime.now();
    ZodiacSign? zodiac = ZodiacSign.fromString(json['zodiac_sign']?.toString());
    zodiac ??= ZodiacSign.fromDate(dob);

    return UserModel(
      id: json['user_id']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      gender: Gender.fromString(json['gender']?.toString()) ?? Gender.other,
      dateOfBirth: dob,
      zodiacSign: zodiac,
      preferredLanguage: json['preferred_language']?.toString() ?? 'en',
      profilePhotoUrl: json['profile_photo_url']?.toString(),
      fcmToken: json['fcm_token']?.toString(),
      birthTime: json['birth_time']?.toString(),
      birthPlace: json['birth_place']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Convert to JSON for FastAPI REST requests (snake_case).
  Map<String, dynamic> toApiJson() {
    return {
      'full_name': fullName,
      'gender': gender.value,
      'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
      'zodiac_sign': zodiacSign?.value,
      'preferred_language': preferredLanguage,
      'profile_photo_url': profilePhotoUrl,
      'fcm_token': fcmToken,
      'birth_time': birthTime,
      'birth_place': birthPlace,
    };
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'email': email,
      'fullName': fullName,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.toAppwriteString(),
      'zodiacSign': zodiacSign?.value,
      'preferredLanguage': preferredLanguage,
      'profilePhotoUrl': profilePhotoUrl,
      'fcmToken': fcmToken,
      'birthTime': birthTime,
      'birthPlace': birthPlace,
      'createdAt': createdAt.toAppwriteString(),
      'updatedAt': updatedAt.toAppwriteString(),
    };
  }

  /// Validate user data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'User ID is required'),
      );
    }

    if (email.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Email is required'),
      );
    }

    // Basic email format validation
    if (!_isValidEmail(email)) {
      return Result.failure(
        const ValidationError(message: 'Invalid email format'),
      );
    }

    if (fullName.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Full name is required'),
      );
    }

    if (fullName.length < 2) {
      return Result.failure(
        const ValidationError(message: 'Full name must be at least 2 characters'),
      );
    }

    // Date of birth should be in the past
    if (dateOfBirth.isAfter(DateTime.now())) {
      return Result.failure(
        const ValidationError(message: 'Date of birth must be in the past'),
      );
    }

    // Reasonable age limit (not older than 150 years)
    final age = DateTime.now().difference(dateOfBirth).inDays ~/ 365;
    if (age > 150) {
      return Result.failure(
        const ValidationError(message: 'Invalid date of birth'),
      );
    }

    return const Result.success(null);
  }

  /// Check if email format is valid.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Create a copy with updated fields.
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    Gender? gender,
    DateTime? dateOfBirth,
    ZodiacSign? zodiacSign,
    String? preferredLanguage,
    String? profilePhotoUrl,
    String? fcmToken,
    String? birthTime,
    String? birthPlace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get user's age from date of birth.
  int get age {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }

  /// Check if user prefers Hindi.
  bool get prefersHindi => preferredLanguage == 'hi';

  /// Check if user has profile photo.
  bool get hasProfilePhoto =>
      profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty;

  /// Get display name (first name only).
  String get firstName => fullName.split(' ').first;

  /// Get initials for avatar placeholder.
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        gender,
        dateOfBirth,
        zodiacSign,
        preferredLanguage,
        profilePhotoUrl,
        fcmToken,
        birthTime,
        birthPlace,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'UserModel(id: $id, email: $email, fullName: $fullName)';
}
