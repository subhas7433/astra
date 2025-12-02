import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

class FeedbackRepository {
  Future<Result<void, AppError>> submitFeedback({
    required String feedback,
    required double rating,
    String? email,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (feedback.isEmpty) {
        return Result.failure(const ValidationError(message: 'Feedback cannot be empty'));
      }

      // In a real app, we would send this to the backend
      print('Feedback submitted: $feedback, Rating: $rating, Email: $email');
      
      return const Result.success(null);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }
}
