import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';
import 'enums/zodiac_sign.dart';
import 'enums/period_type.dart';
import 'enums/horoscope_category.dart';

/// Horoscope prediction model for Appwrite 'horoscopes' collection.
class HoroscopeModel extends Equatable {
  final String id;
  final ZodiacSign zodiacSign;
  final PeriodType periodType;
  final HoroscopeCategory category;
  final String predictionText;
  final String? predictionTextHi;
  final String? tipText;
  final String? tipTextHi;
  final int energyLevel;
  
  // Categories
  final int lovePercentage;
  final String lovePrediction;
  final int careerPercentage;
  final String careerPrediction;
  final int healthPercentage;
  final String healthPrediction;

  // Lucky Items
  final List<int> luckyNumbers;
  final String luckyColor;
  final String luckyTime;

  final DateTime validDate;
  final DateTime createdAt;

  const HoroscopeModel({
    required this.id,
    required this.zodiacSign,
    required this.periodType,
    required this.category,
    required this.predictionText,
    this.predictionTextHi,
    this.tipText,
    this.tipTextHi,
    this.energyLevel = 50,
    
    this.lovePercentage = 0,
    this.lovePrediction = '',
    this.careerPercentage = 0,
    this.careerPrediction = '',
    this.healthPercentage = 0,
    this.healthPrediction = '',
    
    this.luckyNumbers = const [],
    this.luckyColor = '',
    this.luckyTime = '',
    
    required this.validDate,
    required this.createdAt,
  });

  /// Create HoroscopeModel from Appwrite document map.
  factory HoroscopeModel.fromMap(Map<String, dynamic> map) {
    return HoroscopeModel(
      id: map.appwriteId,
      zodiacSign: ZodiacSign.fromString(map.getString('zodiacSign')) ??
          ZodiacSign.aries,
      periodType: PeriodType.fromString(map.getString('periodType')) ??
          PeriodType.daily,
      category: HoroscopeCategory.fromString(map.getString('category')) ??
          HoroscopeCategory.love,
      predictionText: map.getString('predictionText'),
      predictionTextHi: map.getField<String>('predictionTextHi'),
      tipText: map.getField<String>('tipText'),
      tipTextHi: map.getField<String>('tipTextHi'),
      energyLevel: map.getInt('energyLevel', defaultValue: 50),
      
      lovePercentage: map.getInt('lovePercentage', defaultValue: 0),
      lovePrediction: map.getString('lovePrediction'),
      careerPercentage: map.getInt('careerPercentage', defaultValue: 0),
      careerPrediction: map.getString('careerPrediction'),
      healthPercentage: map.getInt('healthPercentage', defaultValue: 0),
      healthPrediction: map.getString('healthPrediction'),
      
      luckyNumbers: List<int>.from(map['luckyNumbers'] ?? []),
      luckyColor: map.getString('luckyColor'),
      luckyTime: map.getString('luckyTime'),
      
      validDate: map.getDateTime('validDate') ?? DateTime.now(),
      createdAt: map.appwriteCreatedAt ?? DateTime.now(),
    );
  }

  /// Convert to map for Appwrite storage.
  Map<String, dynamic> toMap() {
    return {
      'zodiacSign': zodiacSign.value,
      'periodType': periodType.value,
      'category': category.value,
      'predictionText': predictionText,
      'predictionTextHi': predictionTextHi,
      'tipText': tipText,
      'tipTextHi': tipTextHi,
      'energyLevel': energyLevel,
      
      'lovePercentage': lovePercentage,
      'lovePrediction': lovePrediction,
      'careerPercentage': careerPercentage,
      'careerPrediction': careerPrediction,
      'healthPercentage': healthPercentage,
      'healthPrediction': healthPrediction,
      
      'luckyNumbers': luckyNumbers,
      'luckyColor': luckyColor,
      'luckyTime': luckyTime,
      
      'validDate': validDate.toAppwriteString(),
      'createdAt': createdAt.toAppwriteString(),
    };
  }

  /// Validate horoscope data.
  Result<void, AppError> validate() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Horoscope ID is required'),
      );
    }

    if (predictionText.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Prediction text is required'),
      );
    }

    if (predictionText.length < 20) {
      return Result.failure(
        const ValidationError(
            message: 'Prediction text must be at least 20 characters'),
      );
    }

    if (energyLevel < 0 || energyLevel > 100) {
      return Result.failure(
        const ValidationError(
            message: 'Energy level must be between 0 and 100'),
      );
    }

    return const Result.success(null);
  }

  /// Create a copy with updated fields.
  HoroscopeModel copyWith({
    String? id,
    ZodiacSign? zodiacSign,
    PeriodType? periodType,
    HoroscopeCategory? category,
    String? predictionText,
    String? predictionTextHi,
    String? tipText,
    String? tipTextHi,
    int? energyLevel,
    
    int? lovePercentage,
    String? lovePrediction,
    int? careerPercentage,
    String? careerPrediction,
    int? healthPercentage,
    String? healthPrediction,
    
    List<int>? luckyNumbers,
    String? luckyColor,
    String? luckyTime,
    
    DateTime? validDate,
    DateTime? createdAt,
  }) {
    return HoroscopeModel(
      id: id ?? this.id,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      periodType: periodType ?? this.periodType,
      category: category ?? this.category,
      predictionText: predictionText ?? this.predictionText,
      predictionTextHi: predictionTextHi ?? this.predictionTextHi,
      tipText: tipText ?? this.tipText,
      tipTextHi: tipTextHi ?? this.tipTextHi,
      energyLevel: energyLevel ?? this.energyLevel,
      
      lovePercentage: lovePercentage ?? this.lovePercentage,
      lovePrediction: lovePrediction ?? this.lovePrediction,
      careerPercentage: careerPercentage ?? this.careerPercentage,
      careerPrediction: careerPrediction ?? this.careerPrediction,
      healthPercentage: healthPercentage ?? this.healthPercentage,
      healthPrediction: healthPrediction ?? this.healthPrediction,
      
      luckyNumbers: luckyNumbers ?? this.luckyNumbers,
      luckyColor: luckyColor ?? this.luckyColor,
      luckyTime: luckyTime ?? this.luckyTime,
      
      validDate: validDate ?? this.validDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get prediction text based on language preference.
  String getPrediction({bool hindi = false}) {
    if (hindi && predictionTextHi != null && predictionTextHi!.isNotEmpty) {
      return predictionTextHi!;
    }
    return predictionText;
  }

  /// Get tip text based on language preference.
  String? getTip({bool hindi = false}) {
    if (hindi && tipTextHi != null && tipTextHi!.isNotEmpty) {
      return tipTextHi;
    }
    return tipText;
  }

  /// Check if this horoscope has a tip.
  bool get hasTip => tipText != null && tipText!.isNotEmpty;

  /// Check if Hindi translation is available.
  bool get hasHindiPrediction =>
      predictionTextHi != null && predictionTextHi!.isNotEmpty;

  /// Check if Hindi tip is available.
  bool get hasHindiTip => tipTextHi != null && tipTextHi!.isNotEmpty;

  /// Get energy level as percentage string (e.g., "75%").
  String get energyPercentageStr => '$energyLevel%';

  /// Get energy level description.
  String get energyDescription {
    if (energyLevel >= 80) return 'High';
    if (energyLevel >= 60) return 'Good';
    if (energyLevel >= 40) return 'Moderate';
    if (energyLevel >= 20) return 'Low';
    return 'Very Low';
  }

  /// Check if this horoscope is for today.
  bool get isForToday {
    final now = DateTime.now();
    return validDate.year == now.year &&
        validDate.month == now.month &&
        validDate.day == now.day;
  }

  /// Check if this horoscope is still valid (not expired).
  bool get isValid {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    switch (periodType) {
      case PeriodType.daily:
        return validDate.isAfter(todayStart.subtract(const Duration(days: 1)));
      case PeriodType.weekly:
        return validDate.isAfter(todayStart.subtract(const Duration(days: 7)));
      case PeriodType.monthly:
        return validDate.isAfter(todayStart.subtract(const Duration(days: 31)));
      case PeriodType.yearly:
        return validDate.isAfter(todayStart.subtract(const Duration(days: 366)));
    }
  }

  /// Get a unique key for caching (zodiac_period_category_date).
  String get cacheKey {
    final dateStr =
        '${validDate.year}${validDate.month.toString().padLeft(2, '0')}${validDate.day.toString().padLeft(2, '0')}';
    return '${zodiacSign.value}_${periodType.value}_${category.value}_$dateStr';
  }

  @override
  List<Object?> get props => [
        id,
        zodiacSign,
        periodType,
        category,
        predictionText,
        predictionTextHi,
        tipText,
        tipTextHi,
        energyLevel,
        lovePercentage,
        lovePrediction,
        careerPercentage,
        careerPrediction,
        healthPercentage,
        healthPrediction,
        luckyNumbers,
        luckyColor,
        luckyTime,
        validDate,
        createdAt,
      ];

  @override
  String toString() =>
      'HoroscopeModel(id: $id, zodiac: ${zodiacSign.displayName}, period: ${periodType.displayName})';
}
