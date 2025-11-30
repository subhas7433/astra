import 'package:get/get.dart';
import '../../../core/constants/zodiac_constants.dart';
import '../../../data/services/storage_service.dart';

class ZodiacPickerController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final selectedSignId = RxnString();
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedSign();
  }

  void _loadSavedSign() {
    // TODO: Implement persistent storage for zodiac sign in StorageService
    // For now, we can use a simple key in the existing storage service if applicable
    // Or just default to null
  }

  void selectSign(ZodiacSign sign) {
    selectedSignId.value = sign.id;
    // Save to storage
    // _storageService.saveZodiac(sign.id);
    
    // Navigate to Detail Screen (to be implemented)
    // Get.toNamed(AppRoutes.horoscopeDetail, arguments: sign);
    Get.snackbar('Selected', 'You selected ${sign.name}');
  }
}
