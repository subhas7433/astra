import 'package:get/get.dart';

import '../../../data/repositories/palmistry_repository.dart';
import '../controllers/palm_reading_history_controller.dart';

class PalmReadingHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PalmistryRepository>(
      () => PalmistryRepository(),
    );
    Get.lazyPut<PalmReadingHistoryController>(
      () => PalmReadingHistoryController(),
    );
  }
}
