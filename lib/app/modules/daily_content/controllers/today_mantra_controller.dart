import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/mantra_model.dart';
import '../../../data/repositories/daily_content_repository.dart';

class TodayMantraController extends GetxController {
  final DailyContentRepository _repository = Get.find<DailyContentRepository>();
  
  final isLoading = true.obs;
  final mantra = Rxn<MantraModel>();
  final isHindi = false.obs; // TODO: Connect to global language setting
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayMantra();
  }

  Future<void> fetchTodayMantra() async {
    isLoading.value = true;
    final result = await _repository.getTodaysMantra();
    
    result.fold(
      onSuccess: (data) => mantra.value = data,
      onFailure: (error) => Get.snackbar('Error', error.message),
    );
    
    isLoading.value = false;
  }

  void toggleAudio() {
    // TODO: Implement actual audio playback
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      Get.snackbar('Audio', 'Playing mantra audio (Mock)');
      // Simulate audio ending after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        isPlaying.value = false;
      });
    }
  }

  void copyContent() {
    if (mantra.value == null) return;
    
    final text = '''
${mantra.value!.sanskrit}
${mantra.value!.transliteration}

Meaning:
${mantra.value!.getMeaning(isHindi: isHindi.value)}
''';

    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Success', 'Mantra copied to clipboard');
  }

  void shareContent() {
    if (mantra.value == null) return;

    final text = '''
🕉️ Today's Mantra 🕉️

${mantra.value!.sanskrit}

${mantra.value!.transliteration}

Meaning:
${mantra.value!.getMeaning(isHindi: isHindi.value)}

Shared via Astro GPT
''';

    // ignore: deprecated_member_use
    Share.share(text);
  }
}
