import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/today_mantra_controller.dart';
import '../widgets/mantra_display.dart';
import '../widgets/mantra_meaning.dart';
import '../widgets/content_actions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class TodayMantraScreen extends GetView<TodayMantraController> {
  const TodayMantraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Today's Mantra"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final mantra = controller.mantra.value;
        if (mantra == null) {
          return const Center(child: Text('No mantra available for today'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            children: [
              // Mantra Display Card
              MantraDisplay(
                sanskrit: mantra.sanskrit,
                transliteration: mantra.transliteration,
                isPlaying: controller.isPlaying.value,
                onPlayTap: controller.toggleAudio,
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
              
              // Meaning & Benefits
              MantraMeaning(
                meaning: mantra.getMeaning(isHindi: controller.isHindi.value),
                benefits: mantra.benefits,
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
              
              // Actions
              ContentActions(
                onCopy: controller.copyContent,
                onShare: controller.shareContent,
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
            ],
          ),
        );
      }),
    );
  }
}
