import 'package:get/get.dart';
import '../controllers/zodiac_picker_controller.dart';

class ZodiacPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZodiacPickerController>(
      () => ZodiacPickerController(),
    );
  }
}
