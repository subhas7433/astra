import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/modules/auth/auth_controller.dart';
import 'package:astra/app/core/services/interfaces/i_auth_service.dart';
import 'package:astra/app/core/services/mock/mock_auth_service.dart';
import 'package:astra/app/controllers/base_controller.dart';

void main() {
  late AuthController controller;
  late MockAuthService mockAuthService;

  setUpAll(() {
    Get.testMode = true;
  });

  setUp(() {
    // Set up mock auth service first
    mockAuthService = MockAuthService();
    Get.put<IAuthService>(mockAuthService);

    // Create and register controller - Get.put() automatically calls onInit()
    controller = Get.put(AuthController());
  });

  tearDown(() async {
    // Clean up in reverse order
    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>(force: true);
    }
    if (Get.isRegistered<IAuthService>()) {
      Get.delete<IAuthService>(force: true);
    }
    mockAuthService.reset();
    mockAuthService.dispose();
    // Reset GetX state
    Get.reset();
  });

  group('AuthController', () {
    group('initialization', () {
      test('should extend BaseController', () {
        expect(controller, isA<BaseController>());
      });

      test('should have correct tag', () {
        expect(controller.tag, 'AuthController');
      });

      test('should initialize with initial state', () {
        expect(controller.viewState.value, ViewState.initial);
      });

      test('should have empty form controllers', () {
        expect(controller.emailController.text, '');
        expect(controller.passwordController.text, '');
        expect(controller.nameController.text, '');
        expect(controller.confirmPasswordController.text, '');
      });

      test('should have password visibility off by default', () {
        expect(controller.isPasswordVisible.value, isFalse);
        expect(controller.isConfirmPasswordVisible.value, isFalse);
      });
    });

    group('togglePasswordVisibility', () {
      test('should toggle password visibility', () {
        expect(controller.isPasswordVisible.value, isFalse);

        controller.togglePasswordVisibility();
        expect(controller.isPasswordVisible.value, isTrue);

        controller.togglePasswordVisibility();
        expect(controller.isPasswordVisible.value, isFalse);
      });
    });

    group('toggleConfirmPasswordVisibility', () {
      test('should toggle confirm password visibility', () {
        expect(controller.isConfirmPasswordVisible.value, isFalse);

        controller.toggleConfirmPasswordVisibility();
        expect(controller.isConfirmPasswordVisible.value, isTrue);

        controller.toggleConfirmPasswordVisibility();
        expect(controller.isConfirmPasswordVisible.value, isFalse);
      });
    });

    group('login validation', () {
      test('should set error for empty email', () async {
        controller.emailController.text = '';
        controller.passwordController.text = 'password123';

        await controller.login();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter your email');
      });

      test('should set error for invalid email format', () async {
        controller.emailController.text = 'invalid-email';
        controller.passwordController.text = 'password123';

        await controller.login();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter a valid email');
      });

      test('should set error for empty password', () async {
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = '';

        await controller.login();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter your password');
      });

      test('should set error for password less than 6 characters', () async {
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = '12345';

        await controller.login();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value,
            'Password must be at least 6 characters');
      });
    });

    group('login functionality', () {
      test('should fail login for non-existent user', () async {
        controller.emailController.text = 'nonexistent@example.com';
        controller.passwordController.text = 'password123';

        await controller.login();

        expect(controller.hasError, isTrue);
      });

      test('should login successfully with valid credentials', () async {
        // First register a user
        await mockAuthService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );
        await mockAuthService.logout();

        // Now try to login
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = 'password123';

        await controller.login();

        // Should not have error after successful login
        // Note: Navigation Get.offAllNamed() affects state in test mode
        expect(controller.hasError, isFalse);
      });
    });

    group('register validation', () {
      test('should set error for empty name', () async {
        controller.nameController.text = '';
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter your name');
      });

      test('should set error for name less than 2 characters', () async {
        controller.nameController.text = 'A';
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value,
            'Name must be at least 2 characters');
      });

      test('should set error for empty email during registration', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = '';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter your email');
      });

      test('should set error for invalid email during registration', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'invalid-email';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter a valid email');
      });

      test('should set error for empty password during registration', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = '';
        controller.confirmPasswordController.text = '';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Please enter a password');
      });

      test('should set error for password less than 8 characters', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = '1234567';
        controller.confirmPasswordController.text = '1234567';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value,
            'Password must be at least 8 characters');
      });

      test('should set error for mismatched passwords', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'test@example.com';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'different123';

        await controller.register();

        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, 'Passwords do not match');
      });
    });

    group('register functionality', () {
      test('should register successfully with valid data', () async {
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'newuser@example.com';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        // Should not have error after successful registration
        // Note: Navigation Get.offAllNamed() affects state in test mode
        expect(controller.hasError, isFalse);
      });

      test('should fail registration for duplicate email', () async {
        // First registration
        await mockAuthService.registerWithEmail(
          email: 'existing@example.com',
          password: 'password123',
          name: 'Existing User',
        );
        await mockAuthService.logout();

        // Try to register with same email
        controller.nameController.text = 'Test User';
        controller.emailController.text = 'existing@example.com';
        controller.passwordController.text = 'password123';
        controller.confirmPasswordController.text = 'password123';

        await controller.register();

        expect(controller.hasError, isTrue);
      });
    });

    group('form controllers disposal', () {
      test('should have form controllers available before close', () {
        expect(controller.emailController, isA<TextEditingController>());
        expect(controller.passwordController, isA<TextEditingController>());
        expect(controller.nameController, isA<TextEditingController>());
        expect(
            controller.confirmPasswordController, isA<TextEditingController>());
      });
    });

    group('state getters', () {
      test('isLoading should reflect viewState', () {
        expect(controller.isLoading, isFalse);
      });

      test('hasError should reflect viewState', () {
        expect(controller.hasError, isFalse);
      });

      test('isLoaded should reflect viewState', () {
        expect(controller.isLoaded, isFalse);
      });

      test('errorMessage should be empty initially', () {
        expect(controller.errorMessage.value, '');
      });
    });
  });
}
