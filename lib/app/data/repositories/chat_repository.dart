import 'package:appwrite/appwrite.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../models/message_model.dart';

class ChatRepository {
  // Uncomment when Appwrite is fully set up
  // late final Databases _databases = Get.find<AppwriteClientProvider>().databases;
  // late final String _databaseId = Get.find<AppwriteClientProvider>().config.databaseId;
  static const String _collectionsMessages = 'messages';
  static const String _collectionSessions = 'chat_sessions';

  // In-memory storage for mock mode
  final Map<String, List<MessageModel>> _mockMessages = {};
  int _sessionCounter = 0;

  Future<Result<String, AppError>> createSession(String astrologerId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 200));
      final sessionId = 'session_${++_sessionCounter}_${DateTime.now().millisecondsSinceEpoch}';
      _mockMessages[sessionId] = [];
      return Result.success(sessionId);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<void, AppError>> saveMessage(String sessionId, MessageModel message) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 100));
      _mockMessages[sessionId] ??= [];
      _mockMessages[sessionId]!.add(message);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<List<MessageModel>, AppError>> getMessages(String sessionId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 100));
      final messages = _mockMessages[sessionId] ?? [];
      return Result.success(messages);
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }
}
