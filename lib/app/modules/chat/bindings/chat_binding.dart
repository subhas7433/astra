import 'package:get/get.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/interfaces/ai_service_interface.dart';
import '../../../data/services/appwrite_ai_service.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerRepository>(
      () => AstrologerRepository(),
    );
    Get.lazyPut<ChatRepository>(
      () => ChatRepository(),
    );
    Get.lazyPut<IAIService>(
      () => AppwriteAIService(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
