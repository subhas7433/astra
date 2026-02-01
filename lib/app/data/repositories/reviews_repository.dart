import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';
import '../models/review_model.dart';

class ReviewsRepository {
  final ApiClient _api;

  ReviewsRepository() : _api = Get.find<ApiClient>();

  Future<Result<List<ReviewModel>, AppError>> getReviewsByAstrologer(
    String astrologerId, {
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _api.get(
      '/api/v1/astrologers/$astrologerId/reviews',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final reviews = list
            .map((e) => ReviewModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(reviews);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<ReviewModel, AppError>> createReview(ReviewModel review) async {
    final result = await _api.post(
      '/api/v1/reviews',
      data: {
        'astrologer_id': review.astrologerId,
        'rating': review.rating,
        'text': review.text,
      },
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to create review'),
          );
        }
        return Result.success(ReviewModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<double, AppError>> getAverageRating(
      String astrologerId) async {
    // The astrologer detail endpoint includes rating
    final result = await _api.get('/api/v1/astrologers/$astrologerId');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        final rating = (data?['rating'] as num?)?.toDouble() ?? 0.0;
        return Result.success(rating);
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}
