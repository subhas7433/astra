import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/astrologer_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerRepository>(
      () => AstrologerRepository(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
