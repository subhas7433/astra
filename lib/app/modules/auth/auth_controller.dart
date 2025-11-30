import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../core/services/interfaces/i_auth_service.dart';
import '../../core/utils/app_logger.dart';
import '../../routes/app_routes.dart';

/// Authentication controller for login and registration.
///
/// Manages:
/// - Login form state and submission
/// - Registration form state and submission
/// - Navigation on auth success
/// - Error handling
class AuthController extends BaseController {
  static const String _tag = 'AuthController';

  @override
  String get tag => _tag;

  /// Auth service for authentication operations
  late final IAuthService _authService;

  // ============ Form Controllers ============

  /// Email input controller
  final emailController = TextEditingController();

  /// Password input controller
  final passwordController = TextEditingController();

  /// Name input controller (for registration)
  final nameController = TextEditingController();

  /// Confirm password controller (for registration)
  final confirmPasswordController = TextEditingController();

  // ============ Form State ============

  /// Form key for login form validation
  final loginFormKey = GlobalKey<FormState>();

  /// Form key for register form validation
  final registerFormKey = GlobalKey<FormState>();

  /// Password visibility toggle
  final RxBool isPasswordVisible = false.obs;

  /// Confirm password visibility toggle
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<IAuthService>();
  }

  // ============ Login ============

  /// Attempt to login with email and password.
  Future<void> login() async {
    if (!_validateLoginForm()) return;

    AppLogger.info('Attempting login...', tag: _tag);

    await executeWithState(
      operation: () => _authService.loginWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
      onSuccess: (userId) {
        AppLogger.info('Login successful: $userId', tag: _tag);
        _clearForms();
        Get.offAllNamed(AppRoutes.home);
      },
      onError: (error) {
        AppLogger.warning('Login failed: ${error.message}', tag: _tag);
        // Error message is automatically set by executeWithState
      },
    );
  }

  /// Validate login form fields.
  bool _validateLoginForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      setError('Please enter your email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      setError('Please enter a valid email');
      return false;
    }

    if (password.isEmpty) {
      setError('Please enter your password');
      return false;
    }

    if (password.length < 6) {
      setError('Password must be at least 6 characters');
      return false;
    }

    return true;
  }

  // ============ Registration ============

  /// Attempt to register a new user.
  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    AppLogger.info('Attempting registration...', tag: _tag);

    await executeWithState(
      operation: () => _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      ),
      onSuccess: (userId) {
        AppLogger.info('Registration successful: $userId', tag: _tag);
        _clearForms();
        Get.offAllNamed(AppRoutes.home);
      },
      onError: (error) {
        AppLogger.warning('Registration failed: ${error.message}', tag: _tag);
      },
    );
  }

  /// Validate registration form fields.
  bool _validateRegisterForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty) {
      setError('Please enter your name');
      return false;
    }

    if (name.length < 2) {
      setError('Name must be at least 2 characters');
      return false;
    }

    if (email.isEmpty) {
      setError('Please enter your email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      setError('Please enter a valid email');
      return false;
    }

    if (password.isEmpty) {
      setError('Please enter a password');
      return false;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters');
      return false;
    }

    if (password != confirmPassword) {
      setError('Passwords do not match');
      return false;
    }

    return true;
  }

  // ============ Navigation ============

  /// Navigate to registration screen.
  void goToRegister() {
    _clearForms();
    resetState();
    Get.toNamed(AppRoutes.register);
  }

  /// Navigate to login screen.
  void goToLogin() {
    _clearForms();
    resetState();
    Get.back();
  }

  // ============ Helpers ============

  /// Toggle password visibility.
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Clear all form fields.
  void _clearForms() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
