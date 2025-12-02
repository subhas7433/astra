import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import '../models/horoscope_model.dart';
import '../models/enums/zodiac_sign.dart';
import '../models/enums/period_type.dart';
import '../models/enums/horoscope_category.dart';
import '../services/storage_service.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

class HoroscopeRepository {
  final StorageService _storage = Get.find<StorageService>();
  // final Databases _databases = Get.find<Databases>(); // Uncomment when Appwrite is fully set up

  // Collection ID (Replace with actual ID)
  static const String collectionId = 'horoscopes';
  static const String databaseId = 'astra_db';

  Future<Result<HoroscopeModel, AppError>> getHoroscope({
    required ZodiacSign zodiacSign,
    required PeriodType periodType,
    required HoroscopeCategory category,
  }) async {
    try {
      // 1. Check Cache
      final cacheKey = _getCacheKey(zodiacSign, periodType, category);
      final cachedData = _storage.getHoroscope(cacheKey);
      
      if (cachedData != null) {
        final model = HoroscopeModel.fromMap(cachedData);
        if (model.isValid) {
          return Result.success(model);
        }
      }

      // 2. Fetch from Appwrite (Mocked for now)
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Mock Data Generation
      final mockModel = _generateMockData(zodiacSign, periodType, category);
      
      // 3. Cache Result
      _storage.saveHoroscope(cacheKey, mockModel.toMap());

      return Result.success(mockModel);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  String _getCacheKey(ZodiacSign sign, PeriodType period, HoroscopeCategory category) {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month}${now.day}';
    return 'horoscope_${sign.value}_${period.value}_${category.value}_$dateStr';
  }

  HoroscopeModel _generateMockData(ZodiacSign sign, PeriodType period, HoroscopeCategory category) {
    return HoroscopeModel(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      zodiacSign: sign,
      periodType: period,
      category: category,
      predictionText: 'This is a mocked prediction for ${sign.displayName} regarding ${category.displayName} for the ${period.displayName} period. The stars are aligning in a unique way to bring new opportunities.',
      energyLevel: 75 + (sign.index % 25),
      lovePercentage: 60 + (sign.index % 40),
      lovePrediction: 'Love is in the air! Be open to new connections.',
      careerPercentage: 50 + (sign.index % 50),
      careerPrediction: 'Focus on your long-term goals. Hard work pays off.',
      healthPercentage: 70 + (sign.index % 30),
      healthPrediction: 'Maintain a balanced diet and stay hydrated.',
      luckyNumbers: [3, 7, 12, sign.index + 1],
      luckyColor: _getLuckyColor(sign),
      luckyTime: '10:00 AM - 12:00 PM',
      tipText: 'Stay positive and trust the process.',
      validDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  String _getLuckyColor(ZodiacSign sign) {
    switch (sign.element) {
      case 'Fire': return 'Red';
      case 'Earth': return 'Green';
      case 'Air': return 'Blue';
      case 'Water': return 'Teal';
      default: return 'White';
    }
  }
}
