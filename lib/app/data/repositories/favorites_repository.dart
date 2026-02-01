import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';
import '../models/astrologer_model.dart';

class FavoritesRepository {
  final ApiClient _api;

  FavoritesRepository() : _api = Get.find<ApiClient>();

  /// Add astrologer to favorites
  Future<Result<void, AppError>> addFavorite(String astrologerId) async {
    final result = await _api.post(
      '/api/v1/favorites',
      data: {'astrologer_id': astrologerId},
    );
    return result.fold(
      onSuccess: (_) => const Result.success(null),
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Remove astrologer from favorites
  Future<Result<void, AppError>> removeFavorite(String astrologerId) async {
    final result = await _api.delete('/api/v1/favorites/$astrologerId');
    return result.fold(
      onSuccess: (_) => const Result.success(null),
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Check if astrologer is favorited
  Future<Result<bool, AppError>> isFavorite(String astrologerId) async {
    final result = await _api.get('/api/v1/favorites/check/$astrologerId');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        final isFav = data?['is_favorite'] as bool? ?? false;
        return Result.success(isFav);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Get user's favorite astrologers
  Future<Result<List<AstrologerModel>, AppError>> getFavorites() async {
    final result = await _api.get('/api/v1/favorites');
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final astrologers = list.map((e) {
          final item = e as Map<String, dynamic>;
          // FavoriteWithAstrologer has nested astrologer
          final astrologerData = item['astrologer'] as Map<String, dynamic>?;
          if (astrologerData != null) {
            return AstrologerModel.fromApiJson(astrologerData);
          }
          return AstrologerModel.fromApiJson(item);
        }).toList();
        return Result.success(astrologers);
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}
