import 'package:get/get.dart';
import '../controllers/today_mantra_controller.dart';
import '../../../data/repositories/daily_content_repository.dart';

class TodayMantraBinding extends Bindings {
  @override
  void dependencies() {
    // Repository is already put in TodayBhagwanBinding or HomeBinding if needed, 
    // but safe to lazyPut here again or check if registered.
    // Ideally, repositories should be initial bindings or putIfAbsent.
    // For now, we'll just lazyPut it to ensure it's available.
    Get.lazyPut<DailyContentRepository>(() => DailyContentRepository());
    Get.lazyPut<TodayMantraController>(() => TodayMantraController());
  }
}
