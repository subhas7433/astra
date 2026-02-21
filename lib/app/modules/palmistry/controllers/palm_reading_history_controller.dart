import 'package:get/get.dart';

import '../../../core/services/interfaces/i_auth_service.dart';
import '../../../data/models/palm_reading_session_model.dart';
import '../../../data/repositories/palmistry_repository.dart';
import '../../../routes/app_routes.dart';

class PalmReadingHistoryController extends GetxController {
  final PalmistryRepository _palmistryRepository =
      Get.find<PalmistryRepository>();
  final IAuthService _authService = Get.find<IAuthService>();

  // State
  final readings = <PalmReadingSessionModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadReadings();
  }

  Future<void> loadReadings() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final userId = _authService.currentUserId;
    if (userId == null) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'User not authenticated';
      return;
    }

    final result = await _palmistryRepository.getUserReadings(
      userId,
      limit: 50,
      offset: 0,
    );

    result.fold(
      onSuccess: (sessions) {
        readings.assignAll(sessions);
      },
      onFailure: (error) {
        hasError.value = true;
        errorMessage.value = error.message;
      },
    );

    isLoading.value = false;
  }

  void onReadingTap(PalmReadingSessionModel reading) {
    Get.toNamed(AppRoutes.palmReadingChatWithId(reading.id));
  }
}
