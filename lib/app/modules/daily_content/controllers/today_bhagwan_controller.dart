import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/deity_model.dart';
import '../../../data/repositories/daily_content_repository.dart';

class TodayBhagwanController extends GetxController {
  final DailyContentRepository _repository = Get.find<DailyContentRepository>();
  
  final isLoading = true.obs;
  final deity = Rxn<DeityModel>();
  final isHindi = false.obs; // TODO: Connect to global language setting

  @override
  void onInit() {
    super.onInit();
    fetchTodayBhagwan();
  }

  Future<void> fetchTodayBhagwan() async {
    isLoading.value = true;
    final result = await _repository.getTodaysBhagwan();
    
    result.fold(
      onSuccess: (data) => deity.value = data,
      onFailure: (error) => Get.snackbar('Error', error.message),
    );
    
    isLoading.value = false;
  }

  void copyContent() {
    if (deity.value == null) return;
    
    final text = '''
${deity.value!.getName(isHindi: isHindi.value)}

${deity.value!.getDescription(isHindi: isHindi.value)}

${deity.value!.significance}
''';

    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Success', 'Content copied to clipboard');
  }

  void shareContent() {
    if (deity.value == null) return;

    final text = '''
🙏 Today's Bhagwan: ${deity.value!.getName(isHindi: isHindi.value)}

${deity.value!.getDescription(isHindi: isHindi.value)}

${deity.value!.significance}

Shared via Astro GPT
''';

    // ignore: deprecated_member_use
    Share.share(text);
  }
}
