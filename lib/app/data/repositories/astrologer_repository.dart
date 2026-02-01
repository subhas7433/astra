import 'package:get/get.dart';

import '../models/astrologer_model.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';

class AstrologerRepository {
  final ApiClient _api;

  AstrologerRepository() : _api = Get.find<ApiClient>();

  Future<Result<List<AstrologerModel>, AppError>> getAstrologers({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'is_active': true,
    };
    if (category != null && category.isNotEmpty && category != 'all') {
      params['category'] = category;
    }

    final result = await _api.get('/api/v1/astrologers', queryParameters: params);
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final astrologers = list
            .map((e) => AstrologerModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(astrologers);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<AstrologerModel, AppError>> getAstrologerById(String id) async {
    final result = await _api.get('/api/v1/astrologers/$id');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            DocumentNotFoundError(message: 'Astrologer not found'),
          );
        }
        return Result.success(AstrologerModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}
