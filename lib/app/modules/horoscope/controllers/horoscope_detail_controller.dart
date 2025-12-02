import 'package:get/get.dart';
import '../../../core/constants/zodiac_constants.dart' as ui_constants;
import '../../../data/models/horoscope_model.dart';
import '../../../data/models/enums/zodiac_sign.dart';
import '../../../data/models/enums/period_type.dart';
import '../../../data/models/enums/horoscope_category.dart';
import '../../../data/repositories/horoscope_repository.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/services/guest_service.dart';

enum TimePeriod { today, weekly, monthly, yearly }

class HoroscopeDetailController extends GetxController {
  final Rx<TimePeriod> selectedPeriod = TimePeriod.today.obs;
  late final ui_constants.ZodiacSign zodiacSign;
  final HoroscopeRepository _repository = Get.find<HoroscopeRepository>();

  final Rxn<HoroscopeModel> currentHoroscope = Rxn<HoroscopeModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _fetchHoroscope();
  }

  void _loadArguments() {
    final signId = Get.parameters['sign'];
    if (signId != null) {
      zodiacSign = ui_constants.ZodiacConstants.signs.firstWhere(
        (element) => element.id == signId,
        orElse: () => ui_constants.ZodiacConstants.signs.first,
      );
    } else {
      zodiacSign = ui_constants.ZodiacConstants.signs.first;
    }
  }

  void onPeriodChanged(TimePeriod period) {
    selectedPeriod.value = period;
    _fetchHoroscope();
  }

  Future<void> _fetchHoroscope() async {
    isLoading.value = true;
    
    // Convert UI sign ID to Enum
    final zodiacEnum = ZodiacSign.values.firstWhere(
      (e) => e.name.toLowerCase() == zodiacSign.id.toLowerCase(),
      orElse: () => ZodiacSign.aries,
    );

    final result = await _repository.getHoroscope(
      zodiacSign: zodiacEnum,
      periodType: _mapTimePeriodToEnum(selectedPeriod.value),
      category: HoroscopeCategory.general,
    );

    result.fold(
      onSuccess: (success) => currentHoroscope.value = success,
      onFailure: (failure) {
        Get.snackbar('Error', failure.message);
        currentHoroscope.value = null;
      },
    );
    
    isLoading.value = false;
  }

  Future<void> refreshHoroscope() async {
    await _fetchHoroscope();
  }

  PeriodType _mapTimePeriodToEnum(TimePeriod period) {
    switch (period) {
      case TimePeriod.today: return PeriodType.daily;
      case TimePeriod.weekly: return PeriodType.weekly;
      case TimePeriod.monthly: return PeriodType.monthly;
      case TimePeriod.yearly: return PeriodType.yearly;
    }
  }

  // Actions
  final RxBool isLiked = false.obs;

  void toggleLike() {
    if (GuestService.to.isGuest.value) {
      GuestService.to.incrementGuestChat(); // Reusing the prompt logic, or create a specific one
      // Or better, show a specific dialog for features
      Get.dialog(
        AlertDialog(
          title: const Text('Guest Mode'),
          content: const Text('Sign up to save your favorite horoscopes!'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/register'); // Use Routes.REGISTER if available
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      );
      return;
    }
    isLiked.value = !isLiked.value;
    // TODO: Persist like state
  }

  void shareHoroscope() {
    if (currentHoroscope.value == null) return;
    
    String content = _generateShareContent(currentHoroscope.value!);
    Share.share(content);
  }

  String _generateShareContent(HoroscopeModel horoscope) {
    return '''
🌟 ${zodiacSign.name} Horoscope for Today 🌟

${horoscope.predictionText}

❤️ Love: ${horoscope.lovePercentage}%
💼 Career: ${horoscope.careerPercentage}%
💪 Health: ${horoscope.healthPercentage}%

Lucky Number: ${horoscope.luckyNumbers.join(', ')}
Lucky Color: ${horoscope.luckyColor}

Download Astro GPT for more! 
#AstroGPT #Horoscope #${zodiacSign.name}
''';
  }
}
