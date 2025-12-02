import 'package:get/get.dart';
import '../controllers/horoscope_detail_controller.dart';
import '../../../data/repositories/horoscope_repository.dart';

class HoroscopeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HoroscopeRepository>(
      () => HoroscopeRepository(),
    );
    Get.lazyPut<HoroscopeDetailController>(
      () => HoroscopeDetailController(),
    );
  }
}
