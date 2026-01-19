import 'dart:math';
import '../../result/result.dart';
import '../../result/app_error.dart';
import '../interfaces/i_ai_service.dart';

class MockAIService implements IAIService {
  @override
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final responses = [
      "The stars align in your favor today. Trust your intuition.",
      "Mars is influencing your energy levels. Take some time to rest.",
      "A new opportunity is on the horizon. Be open to change.",
      "Relationships may be tested, but patience will yield rewards.",
      "Focus on your inner growth this week. Medicaid will help."
    ];
    
    return Result.success(responses[Random().nextInt(responses.length)]);
  }

  @override
  Future<Result<String, AppError>> getGreeting({
    required String userId,
    required String astrologerId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Result.success("Namaste! I am here to guide you through the wisdom of the stars. What seeks clarity in your life today?");
  }
}
