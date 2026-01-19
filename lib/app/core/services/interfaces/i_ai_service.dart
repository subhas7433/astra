import '../../result/result.dart';
import '../../result/app_error.dart';

abstract class IAIService {
  /// Generate a response from the AI astrologer
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  });

  /// Get a personalized greeting for a new session
  Future<Result<String, AppError>> getGreeting({
    required String userId,
    required String astrologerId,
  });
}
