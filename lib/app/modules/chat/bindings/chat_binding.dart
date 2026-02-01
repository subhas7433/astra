import 'package:get/get.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/chat_repository.dart';
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
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
