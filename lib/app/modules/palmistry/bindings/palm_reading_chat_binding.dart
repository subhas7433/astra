import 'package:get/get.dart';

import '../../../data/repositories/palmistry_repository.dart';
import '../controllers/palm_reading_chat_controller.dart';

class PalmReadingChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PalmistryRepository>(
      () => PalmistryRepository(),
    );
    Get.lazyPut<PalmReadingChatController>(
      () => PalmReadingChatController(),
    );
  }
}
