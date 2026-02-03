import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/feedback/error_box.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/inputs/password_field.dart';
import 'auth_controller.dart';

/// Registration screen for new users.
///
/// Features:
/// - Name/email/password input
/// - Password confirmation
/// - Form validation
/// - Loading state
/// - Error display
/// - Navigation back to login
class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: controller.goToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: AppDimensions.md),

              // Register Form
              _buildRegisterForm(),
              const SizedBox(height: AppDimensions.md),

              // Terms & Privacy Checkbox
              _buildTermsCheckbox(),
              const SizedBox(height: AppDimensions.sm),

              // Error Message
              ErrorBox.reactive(rxMessage: controller.errorMessage),
              const SizedBox(height: AppDimensions.md),

              // Register Button
              Obx(() => AppButton.primary(
                    label: 'Create Account',
                    onPressed: controller.register,
                    isLoading: controller.isLoading,
                  )),
              const SizedBox(height: AppDimensions.md),

              // Login Link
              _buildLoginLink(context),
              const SizedBox(height: AppDimensions.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: AppTypography.h2,
        ),
        const SizedBox(height: 4),
        Text(
          'Start your astrological journey',
          style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Name Field
        AppTextField(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: controller.nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: AppDimensions.sm),

        // Email Field
        AppTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: AppDimensions.sm),

        // Date of Birth Field
        Obx(() {
          final dob = controller.dateOfBirth.value;
          final displayText = dob != null
              ? '${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year}'
              : '';
          return GestureDetector(
            onTap: () => controller.pickDateOfBirth(Get.context!),
            child: AbsorbPointer(
              child: AppTextField(
                label: 'Date of Birth',
                hint: 'Select your date of birth',
                controller: TextEditingController(text: displayText),
                prefixIcon: Icons.cake_outlined,
                textInputAction: TextInputAction.next,
              ),
            ),
          );
        }),
        const SizedBox(height: AppDimensions.sm),

        // Password Field
        PasswordField(
          label: 'Password',
          hint: 'Enter your password (min 8 characters)',
          controller: controller.passwordController,
          visibilityState: controller.isPasswordVisible,
          onToggleVisibility: controller.togglePasswordVisibility,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppDimensions.sm),

        // Confirm Password Field
        PasswordField(
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          controller: controller.confirmPasswordController,
          visibilityState: controller.isConfirmPasswordVisible,
          onToggleVisibility: controller.toggleConfirmPasswordVisibility,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: controller.termsAccepted.value,
                onChanged: (_) => controller.toggleTermsAcceptance(),
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final uri = Uri.parse(AppConstants.termsOfServiceUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final uri = Uri.parse(AppConstants.privacyPolicyUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTypography.body2,
        ),
        AppButton.text(
          label: 'Sign In',
          onPressed: controller.goToLogin,
          fullWidth: false,
          height: 32,
        ),
      ],
    );
  }
}
