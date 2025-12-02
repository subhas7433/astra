import 'package:get/get.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../models/message_model.dart';

class ChatRepository {
  // final Databases _databases = Get.find<Databases>(); // Uncomment when Appwrite is fully set up

  // In-memory storage for mock persistence
  final Map<String, List<MessageModel>> _mockSessions = {};

  Future<Result<String, AppError>> createSession(String astrologerId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      _mockSessions[sessionId] = [];
      return Result.success(sessionId);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<void, AppError>> saveMessage(String sessionId, MessageModel message) async {
    try {
      // await Future.delayed(const Duration(milliseconds: 200));
      if (!_mockSessions.containsKey(sessionId)) {
        _mockSessions[sessionId] = [];
      }
      _mockSessions[sessionId]!.add(message);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<List<MessageModel>, AppError>> getMessages(String sessionId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(_mockSessions[sessionId] ?? []);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }
}
