import 'package:get/get.dart';
import '../controllers/astrologer_profile_controller.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/reviews_repository.dart';

class AstrologerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerRepository>(() => AstrologerRepository());
    Get.lazyPut<ReviewsRepository>(() => ReviewsRepository());
    Get.lazyPut<AstrologerProfileController>(
      () => AstrologerProfileController(),
    );
  }
}
