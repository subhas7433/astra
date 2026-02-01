import 'package:get/get.dart';

import '../models/faq_model.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';

class FAQsRepository {
  final ApiClient _api;

  FAQsRepository() : _api = Get.find<ApiClient>();

  Future<Result<List<FAQModel>, AppError>> getFAQs({
    String? category,
    String? astrologerId,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'active_only': true,
    };
    if (category != null && category.isNotEmpty) {
      params['category'] = category;
    }
    if (astrologerId != null && astrologerId.isNotEmpty) {
      params['astrologer_id'] = astrologerId;
    }

    final result = await _api.get('/api/v1/faqs', queryParameters: params);
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final faqs = list
            .map((e) => FAQModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(faqs);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<List<FAQModel>, AppError>> getMostAskedQuestions({
    int limit = 10,
  }) async {
    return getFAQs(limit: limit);
  }

  Future<Result<List<FAQModel>, AppError>> getFAQsByCategory(
    String category, {
    int limit = 20,
  }) async {
    return getFAQs(category: category, limit: limit);
  }

  Future<Result<List<FAQModel>, AppError>> getFAQsByAstrologer(
    String astrologerId, {
    int limit = 20,
  }) async {
    final result = await _api.get(
      '/api/v1/astrologers/$astrologerId/faqs',
      queryParameters: {'limit': limit},
    );
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final faqs = list
            .map((e) => FAQModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(faqs);
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}
