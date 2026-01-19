import 'dart:ui';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';

class LanguageController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final selectedLocale = const Locale('en', 'US').obs;

  final languages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Hindi', 'locale': const Locale('hi', 'IN')},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void _loadLocale() {
    final savedLocale = _storageService.getLocale();
    if (savedLocale != null) {
      selectedLocale.value = savedLocale;
      Get.updateLocale(savedLocale);
    } else {
      selectedLocale.value = Get.deviceLocale ?? const Locale('en', 'US');
    }
  }

  void updateLocale(Locale locale) {
    selectedLocale.value = locale;
    Get.updateLocale(locale);
    _storageService.saveLocale(locale);
  }
}
