import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Privacy Policy', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Text(
          '''
1. Introduction
Welcome to Astra. We respect your privacy and are committed to protecting your personal data.

2. Data We Collect
We collect information you provide directly to us, such as your name, birth details, and chat history.

3. How We Use Your Data
We use your data to provide personalized astrological readings and connect you with astrologers.

4. Data Security
We implement appropriate security measures to protect your personal data.

5. Contact Us
If you have any questions about this Privacy Policy, please contact us.
          ''',
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }
}
