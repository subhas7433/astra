import 'package:get/get.dart';

import '../../../data/repositories/palmistry_repository.dart';
import '../controllers/palm_reading_controller.dart';

class PalmReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PalmistryRepository>(
      () => PalmistryRepository(),
    );
    Get.lazyPut<PalmReadingController>(
      () => PalmReadingController(),
    );
  }
}
