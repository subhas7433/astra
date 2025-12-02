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

/// Login screen for user authentication.
///
/// Features:
/// - Email/password input
/// - Form validation
/// - Loading state
/// - Error display
/// - Navigation to registration
class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.xxl * 2),

              // Header
              _buildHeader(context),
              const SizedBox(height: AppDimensions.xxl),

              // Login Form
              _buildLoginForm(),
              const SizedBox(height: AppDimensions.lg),

              // Error Message
              ErrorBox.reactive(rxMessage: controller.errorMessage),
              const SizedBox(height: AppDimensions.lg),

              // Login Button
              Obx(() => AppButton.primary(
                    label: 'Sign In',
                    onPressed: controller.login,
                    isLoading: controller.isLoading,
                  )),
              Obx(() => AppButton.primary(
                    label: 'Sign In',
                    onPressed: controller.login,
                    isLoading: controller.isLoading,
                  )),
              const SizedBox(height: AppDimensions.md),

              // Google Sign-In Button
              Obx(() => AppButton.outline(
                    label: 'Sign in with Google',
                    onPressed: controller.signInWithGoogle,
                    isLoading: controller.isLoading,
                    icon: Icons.g_mobiledata, // Or use a custom SVG icon
                  )),
              const SizedBox(height: AppDimensions.lg),

              // Guest Mode
              Center(
                child: TextButton(
                  onPressed: () => GuestService.to.enterGuestMode(),
                  child: Text(
                    'Continue as Guest',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.lg),

              // Register Link
              _buildRegisterLink(context),
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
          'Welcome Back',
          style: AppTypography.h1,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          'Sign in to continue your astrological journey',
          style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
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
          hint: 'Enter your password',
          controller: controller.passwordController,
          visibilityState: controller.isPasswordVisible,
          onToggleVisibility: controller.togglePasswordVisibility,
          textInputAction: TextInputAction.done,
          onChanged: (_) {}, // Optional: handle change if needed
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.body2,
        ),
        AppButton.text(
          label: 'Sign Up',
          onPressed: controller.goToRegister,
          fullWidth: false,
          height: 32,
        ),
      ],
    );
  }
}
