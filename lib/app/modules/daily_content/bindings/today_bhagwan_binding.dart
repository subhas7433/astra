import 'package:get/get.dart';
import '../controllers/today_bhagwan_controller.dart';
import '../../../data/repositories/daily_content_repository.dart';

class TodayBhagwanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyContentRepository>(() => DailyContentRepository());
    Get.lazyPut<TodayBhagwanController>(() => TodayBhagwanController());
  }
}
