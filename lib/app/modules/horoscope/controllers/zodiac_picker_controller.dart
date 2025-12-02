import 'package:get/get.dart';
import '../../../core/constants/zodiac_constants.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class ZodiacPickerController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final selectedSignId = RxnString();
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedSign();
  }

  void _loadSavedSign() {
    final savedSign = _storageService.getZodiac();
    if (savedSign != null) {
      selectedSignId.value = savedSign;
    }
  }

  void selectSign(ZodiacSign sign) {
    selectedSignId.value = sign.id;
    // Save to storage
    _storageService.saveZodiac(sign.id);
    
    // Navigate to Detail Screen
    Get.toNamed(
      AppRoutes.horoscopeDetailWithSign(sign.id),
      parameters: {'sign': sign.id},
    );
  }
}
