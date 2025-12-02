import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/feedback/error_box.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/inputs/password_field.dart';
import '../../widgets/inputs/password_field.dart';
import '../../data/services/guest_service.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: controller.goToLogin,
        ),
        actions: [
          TextButton(
            onPressed: () => GuestService.to.enterGuestMode(),
            child: Text(
              'Maybe Later',
              style: AppTypography.body2.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: AppDimensions.xl),

              // Register Form
              _buildRegisterForm(),
              const SizedBox(height: AppDimensions.lg),

              // Error Message
              ErrorBox.reactive(rxMessage: controller.errorMessage),
              const SizedBox(height: AppDimensions.lg),

              // Register Button
              Obx(() => AppButton.primary(
                    label: 'Create Account',
                    onPressed: controller.register,
                    isLoading: controller.isLoading,
                  )),
              const SizedBox(height: AppDimensions.lg),

              // Login Link
              _buildLoginLink(context),
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
          style: AppTypography.h1,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          'Start your astrological journey today',
          style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
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
        const SizedBox(height: AppDimensions.md),

        // Email Field
        AppTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: AppDimensions.md),

        // Password Field
        PasswordField(
          label: 'Password',
          hint: 'Enter your password (min 8 characters)',
          controller: controller.passwordController,
          visibilityState: controller.isPasswordVisible,
          onToggleVisibility: controller.togglePasswordVisibility,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppDimensions.md),

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
