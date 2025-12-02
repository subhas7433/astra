import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Terms of Service', style: AppTextStyles.headlineSmall),
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
1. Acceptance of Terms
By accessing or using Astra, you agree to be bound by these Terms of Service.

2. User Accounts
You are responsible for maintaining the confidentiality of your account credentials.

3. Services
We provide astrological content and consultation services. These are for entertainment purposes only.

4. User Conduct
You agree not to misuse our services or harass our astrologers.

5. Termination
We reserve the right to terminate or suspend your account at our sole discretion.
          ''',
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }
}
