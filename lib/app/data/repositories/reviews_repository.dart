import 'package:get/get.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../models/review_model.dart';

class ReviewsRepository {
  // final Databases _databases = Get.find<Databases>(); // Uncomment when Appwrite is fully set up

  Future<Result<List<ReviewModel>, AppError>> getReviewsByAstrologer(
    String astrologerId, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 800));
      return Result.success(_generateMockReviews(astrologerId, limit));
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<ReviewModel, AppError>> createReview(ReviewModel review) async {
    try {
      // Mock creation
      await Future.delayed(const Duration(milliseconds: 1000));
      return Result.success(review);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<double, AppError>> getAverageRating(String astrologerId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return Result.success(4.8); // Mock average
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  List<ReviewModel> _generateMockReviews(String astrologerId, int count) {
    return List.generate(count, (index) {
      return ReviewModel(
        id: 'review_$index',
        astrologerId: astrologerId,
        userId: 'user_$index',
        userName: 'User ${index + 1}',
        rating: 4 + (index % 2), // 4 or 5 stars
        text: 'Great experience! Very accurate predictions and helpful advice.',
        createdAt: DateTime.now().subtract(Duration(days: index * 2)),
      );
    });
  }
}
