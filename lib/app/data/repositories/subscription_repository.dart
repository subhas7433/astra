import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';

class SubscriptionRepository {
  final ApiClient _api;

  SubscriptionRepository() : _api = Get.find<ApiClient>();

  /// Get user's subscription
  Future<Result<SubscriptionData, AppError>> getSubscription(
      String userId) async {
    final result = await _api.get('/api/v1/subscriptions/$userId');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return Result.success(SubscriptionData.free());
        }
        return Result.success(SubscriptionData.fromApiJson(data));
      },
      onFailure: (_) => Result.success(SubscriptionData.free()),
    );
  }

  /// Create or update subscription
  Future<Result<SubscriptionData, AppError>> updateSubscription({
    required String userId,
    required String tier,
    required String platform,
    String? productId,
    String? transactionId,
  }) async {
    final result = await _api.post(
      '/api/v1/subscriptions',
      data: {
        'user_id': userId,
        'tier': tier,
        'platform': platform,
        'product_id': productId,
        'transaction_id': transactionId,
      },
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to update subscription'),
          );
        }
        return Result.success(SubscriptionData.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Deduct chat credits
  Future<Result<int, AppError>> deductCredits({
    required String userId,
    int amount = 1,
  }) async {
    final result = await _api.post(
      '/api/v1/subscriptions/$userId/deduct-credits',
      data: {'amount': amount},
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        final remaining = (data?['chat_credits'] as num?)?.toInt() ?? 0;
        return Result.success(remaining);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Add chat credits (e.g. after watching ad)
  Future<Result<int, AppError>> addCredits({
    required String userId,
    int amount = 3,
  }) async {
    final result = await _api.post(
      '/api/v1/subscriptions/$userId/add-credits',
      data: {'amount': amount},
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        final remaining = (data?['chat_credits'] as num?)?.toInt() ?? 0;
        return Result.success(remaining);
      },
      onFailure: (error) => Result.failure(error),
    );
  }
}

class SubscriptionData {
  final String id;
  final String tier;
  final String status;
  final int chatCredits;
  final bool adsRemoved;
  final DateTime? startDate;
  final DateTime? endDate;

  const SubscriptionData({
    required this.id,
    required this.tier,
    required this.status,
    required this.chatCredits,
    required this.adsRemoved,
    this.startDate,
    this.endDate,
  });

  factory SubscriptionData.free() {
    return const SubscriptionData(
      id: '',
      tier: 'free',
      status: 'active',
      chatCredits: 3,
      adsRemoved: false,
    );
  }

  factory SubscriptionData.fromApiJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json['id']?.toString() ?? '',
      tier: json['tier']?.toString() ?? 'free',
      status: json['status']?.toString() ?? 'active',
      chatCredits: (json['chat_credits'] as num?)?.toInt() ?? 0,
      adsRemoved: json['ads_removed'] as bool? ?? false,
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? ''),
      endDate: DateTime.tryParse(json['end_date']?.toString() ?? ''),
    );
  }

  bool get isPremium => tier != 'free' && status == 'active';
  bool get hasCredits => chatCredits > 0;
}
