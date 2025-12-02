import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

abstract class IAIService {
  Future<String> generateResponse(String message, String astrologerName);
}
