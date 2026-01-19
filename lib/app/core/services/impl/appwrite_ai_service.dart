import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:get/get.dart';
import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../../../data/providers/appwrite_client_provider.dart';
import '../interfaces/i_ai_service.dart';

class AppwriteAIService extends GetxService implements IAIService {
  static const String _tag = 'AppwriteAIService';
  final AppwriteClientProvider _provider;

  // Function ID should match what's deployed
  static const String _functionId = 'ai-chat-response';

  AppwriteAIService(this._provider);

  @override
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  }) async {
    try {
      AppLogger.debug('Calling function $_functionId', tag: _tag);
      final execution = await _provider.functions.createExecution(
        functionId: _functionId,
        body: jsonEncode({
          'userId': userId,
          'astrologerId': astrologerId,
          'message': message,
          'sessionId': sessionId,
        }),
        method: ExecutionMethod.pOST,
      );

      AppLogger.debug('Function response status: ${execution.status}', tag: _tag);
      final responseBody = execution.responseBody;
      if (responseBody.isEmpty) {
        AppLogger.error('Empty response from function', tag: _tag);
        return const Result.failure(ServerError(message: 'Empty response from AI service'));
      }

      final data = jsonDecode(responseBody);
      AppLogger.debug('Function response: $data', tag: _tag);

      if (data['success'] == true) {
        return Result.success(data['response'] as String);
      } else {
        return Result.failure(ServerError(message: data['error'] ?? 'Unknown error from AI service'));
      }
    } on AppwriteException catch (e) {
      AppLogger.error('Appwrite error: ${e.code} - ${e.message}', tag: _tag);
      return Result.failure(ServerError(message: e.message ?? 'Appwrite function error (code: ${e.code})'));
    } catch (e) {
      AppLogger.error('Unknown error: $e', tag: _tag);
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Result<String, AppError>> getGreeting({
    required String userId,
    required String astrologerId,
  }) async {
    try {
      AppLogger.debug('Calling greeting function $_functionId', tag: _tag);
      final execution = await _provider.functions.createExecution(
        functionId: _functionId,
        body: jsonEncode({
          'action': 'greeting',
          'userId': userId,
          'astrologerId': astrologerId,
        }),
        method: ExecutionMethod.pOST,
      );

      AppLogger.debug('Greeting function response status: ${execution.status}', tag: _tag);
      final responseBody = execution.responseBody;
      if (responseBody.isEmpty) {
        AppLogger.error('Empty response from greeting function', tag: _tag);
        return const Result.failure(ServerError(message: 'Empty response from AI service'));
      }

      final data = jsonDecode(responseBody);
      AppLogger.debug('Greeting function response: $data', tag: _tag);

      if (data['success'] == true) {
        return Result.success(data['greeting'] as String);
      } else {
        return Result.failure(ServerError(message: data['error'] ?? 'Unknown error from AI service'));
      }
    } on AppwriteException catch (e) {
      AppLogger.error('Greeting Appwrite error: ${e.code} - ${e.message}', tag: _tag);
      return Result.failure(ServerError(message: e.message ?? 'Appwrite function error (code: ${e.code})'));
    } catch (e) {
      AppLogger.error('Greeting unknown error: $e', tag: _tag);
      return Result.failure(UnknownError(message: e.toString()));
    }
  }
}
