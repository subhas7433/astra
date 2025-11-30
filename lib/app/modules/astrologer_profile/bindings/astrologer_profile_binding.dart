import 'package:get/get.dart';
import '../controllers/astrologer_profile_controller.dart';

class AstrologerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerProfileController>(
      () => AstrologerProfileController(),
    );
  }
}
