import 'package:get/get.dart';
import '../controllers/astrologer_profile_controller.dart';
import '../../../data/repositories/reviews_repository.dart';

class AstrologerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsRepository>(() => ReviewsRepository());
    Get.lazyPut<AstrologerProfileController>(
      () => AstrologerProfileController(),
    );
  }
}
