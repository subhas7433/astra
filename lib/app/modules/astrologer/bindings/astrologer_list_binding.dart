import 'package:get/get.dart';
import '../controllers/astrologer_list_controller.dart';

class AstrologerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerListController>(
      () => AstrologerListController(),
    );
  }
}
