import 'package:get/get.dart';

import '../models/horoscope_model.dart';
import '../models/enums/zodiac_sign.dart';
import '../models/enums/period_type.dart';
import '../models/enums/horoscope_category.dart';
import '../services/storage_service.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';

class HoroscopeRepository {
  final ApiClient _api;
  final StorageService _storage;

  HoroscopeRepository()
      : _api = Get.find<ApiClient>(),
        _storage = Get.find<StorageService>();

  Future<Result<HoroscopeModel, AppError>> getHoroscope({
    required ZodiacSign zodiacSign,
    required PeriodType periodType,
    required HoroscopeCategory category,
  }) async {
    // 1. Check local cache
    final cacheKey = _getCacheKey(zodiacSign, periodType, category);
    final cachedData = _storage.getHoroscope(cacheKey);
    if (cachedData != null) {
      final model = HoroscopeModel.fromMap(cachedData);
      if (model.isValid) {
        return Result.success(model);
      }
    }

    // 2. Fetch from FastAPI
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final params = <String, dynamic>{
      'zodiac_sign': zodiacSign.value,
      'period_type': periodType.value,
      'valid_date': dateStr,
    };
    // Backend only accepts love/career/health -- 'general' means fetch all
    if (category != HoroscopeCategory.general) {
      params['category'] = category.value;
    }

    final result = await _api.get('/api/v1/horoscopes', queryParameters: params);
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        if (list.isEmpty) {
          return Result.success(
            _generateFallback(zodiacSign, periodType, category),
          );
        }
        final model =
            HoroscopeModel.fromApiJson(list.first as Map<String, dynamic>);

        // 3. Cache result
        _storage.saveHoroscope(cacheKey, model.toMap());

        return Result.success(model);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get today's horoscope for a zodiac sign (convenience shortcut)
  Future<Result<HoroscopeModel, AppError>> getTodayHoroscope(
      ZodiacSign zodiacSign) async {
    final result =
        await _api.get('/api/v1/horoscopes/today/${zodiacSign.value}');
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        if (list.isEmpty) {
          return Result.success(_generateFallback(
              zodiacSign, PeriodType.daily, HoroscopeCategory.love));
        }
        return Result.success(
            HoroscopeModel.fromApiJson(list.first as Map<String, dynamic>));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  String _getCacheKey(
      ZodiacSign sign, PeriodType period, HoroscopeCategory category) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'horoscope_${sign.value}_${period.value}_${category.value}_$dateStr';
  }

  HoroscopeModel _generateFallback(
      ZodiacSign sign, PeriodType period, HoroscopeCategory category) {
    return HoroscopeModel(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      zodiacSign: sign,
      periodType: period,
      category: category,
      predictionText:
          'The cosmic energies are aligning for ${sign.displayName}. Today brings opportunities for growth in ${category.displayName.toLowerCase()}. Trust your intuition and stay open to new possibilities.',
      energyLevel: 70,
      validDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
}
