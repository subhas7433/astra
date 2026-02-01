import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/daily_content_repository.dart';
import '../../../data/repositories/faqs_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerRepository>(
      () => AstrologerRepository(),
    );
    Get.lazyPut<DailyContentRepository>(
      () => DailyContentRepository(),
    );
    Get.lazyPut<FAQsRepository>(
      () => FAQsRepository(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
