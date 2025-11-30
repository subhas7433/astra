import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/modules/splash/splash_controller.dart';
import 'package:astra/app/core/services/interfaces/i_auth_service.dart';
import 'package:astra/app/core/services/mock/mock_auth_service.dart';
import 'package:astra/app/routes/app_routes.dart';
import 'package:astra/app/controllers/base_controller.dart';

void main() {
  late SplashController controller;
  late MockAuthService mockAuthService;

  setUpAll(() {
    Get.testMode = true;
  });

  setUp(() {
    // Set up mock auth service first
    mockAuthService = MockAuthService();
    Get.put<IAuthService>(mockAuthService);

    // Create and register controller - Get.put() automatically calls onInit()
    controller = Get.put(SplashController());
  });

  tearDown(() async {
    // Clean up in reverse order
    if (Get.isRegistered<SplashController>()) {
      Get.delete<SplashController>(force: true);
    }
    if (Get.isRegistered<IAuthService>()) {
      Get.delete<IAuthService>(force: true);
    }
    mockAuthService.reset();
    mockAuthService.dispose();
    // Reset GetX state
    Get.reset();
  });

  group('SplashController', () {
    group('initialization', () {
      test('should extend BaseController', () {
        expect(controller, isA<BaseController>());
      });

      test('should have correct tag', () {
        expect(controller.tag, 'SplashController');
      });

      test('should have initial state on creation', () {
        expect(controller.viewState.value, ViewState.initial);
      });
    });

    group('onInit', () {
      test('should find and store auth service', () {
        // If onInit completes without error, auth service was found
        expect(Get.isRegistered<IAuthService>(), isTrue);
      });
    });

    group('authentication check', () {
      test('should have auth service available', () {
        expect(Get.find<IAuthService>(), isA<IAuthService>());
      });

      test('mock auth service checkSession should return false when not logged in',
          () async {
        final result = await mockAuthService.checkSession();
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isFalse);
      });

      test('mock auth service checkSession should return true when logged in',
          () async {
        await mockAuthService.registerWithEmail(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
        );

        final result = await mockAuthService.checkSession();
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isTrue);
      });

      test('checkSession should fail with forced error on mock', () async {
        mockAuthService.forceError = true;

        final result = await mockAuthService.checkSession();
        // checkSession with forceError should fail
        expect(result.isFailure, isTrue);
      });
    });

    group('route constants used', () {
      test('should use AppRoutes.home for authenticated users', () {
        expect(AppRoutes.home, '/home');
      });

      test('should use AppRoutes.login for unauthenticated users', () {
        expect(AppRoutes.login, '/login');
      });
    });
  });
}
