import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/zodiac_constants.dart';
import '../controllers/zodiac_picker_controller.dart';
import '../widgets/zodiac_card.dart';

class ZodiacPickerScreen extends GetView<ZodiacPickerController> {
  const ZodiacPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horoscope'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.lg),
          Text(
            'Select Your Rashi',
            style: AppTypography.h2,
          ),
          Text(
            'Choose your zodiac sign to see predictions',
            style: AppTypography.body2,
          ),
          const SizedBox(height: AppDimensions.xl),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: AppDimensions.md,
                mainAxisSpacing: AppDimensions.md,
              ),
              itemCount: ZodiacConstants.signs.length,
              itemBuilder: (context, index) {
                final sign = ZodiacConstants.signs[index];
                return Obx(() => ZodiacCard(
                  sign: sign,
                  isSelected: controller.selectedSignId.value == sign.id,
                  onTap: () => controller.selectSign(sign),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
