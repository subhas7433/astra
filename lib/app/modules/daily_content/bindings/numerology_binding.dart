import 'package:get/get.dart';
import '../controllers/numerology_controller.dart';
import '../../../data/repositories/daily_content_repository.dart';

class NumerologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyContentRepository>(() => DailyContentRepository());
    Get.lazyPut<NumerologyController>(() => NumerologyController());
  }
}
