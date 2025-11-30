import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/core/services/mock/mock_auth_service.dart';
import 'package:astra/app/core/result/app_error.dart';

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  tearDown(() {
    authService.reset();
    authService.dispose();
  });

  group('MockAuthService', () {
    group('registerWithEmail', () {
      test('should register new user successfully', () async {
        final result = await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNotNull);
        expect(authService.currentUserId, result.valueOrNull);
      });

      test('should return error if email already exists', () async {
        // First registration
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        // Second registration with same email
        final result = await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'different123',
          name: 'Another User',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<EmailAlreadyExistsError>());
      });

      test('should return forced error when forceError is true', () async {
        authService.forceError = true;
        authService.forcedError = const NetworkError(message: 'Test error');

        final result = await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<NetworkError>());
      });
    });

    group('loginWithEmail', () {
      test('should login successfully with correct credentials', () async {
        // Register first
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        // Logout
        await authService.logout();

        // Login
        final result = await authService.loginWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result.isSuccess, isTrue);
        expect(authService.currentUserId, isNotNull);
      });

      test('should return error for non-existent user', () async {
        final result = await authService.loginWithEmail(
          email: 'nonexistent@example.com',
          password: 'password123',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<UserNotFoundError>());
      });

      test('should return error for wrong password', () async {
        // Register first
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        await authService.logout();

        // Login with wrong password
        final result = await authService.loginWithEmail(
          email: 'test@example.com',
          password: 'wrongpassword',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<InvalidCredentialsError>());
      });
    });

    group('logout', () {
      test('should logout successfully', () async {
        // Register and verify logged in
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );
        expect(authService.currentUserId, isNotNull);

        // Logout
        final result = await authService.logout();

        expect(result.isSuccess, isTrue);
        expect(authService.currentUserId, isNull);
      });
    });

    group('checkSession', () {
      test('should return true when logged in', () async {
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        final result = await authService.checkSession();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isTrue);
      });

      test('should return false when not logged in', () async {
        final result = await authService.checkSession();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isFalse);
      });
    });

    group('deleteAccount', () {
      test('should delete account successfully', () async {
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        final result = await authService.deleteAccount();

        expect(result.isSuccess, isTrue);
        expect(authService.currentUserId, isNull);

        // Should not be able to login anymore
        final loginResult = await authService.loginWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );
        expect(loginResult.isFailure, isTrue);
      });

      test('should return error when not logged in', () async {
        final result = await authService.deleteAccount();

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<SessionExpiredError>());
      });
    });

    group('updatePassword', () {
      test('should update password successfully', () async {
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'oldpassword',
          name: 'Test User',
        );

        final result = await authService.updatePassword(
          oldPassword: 'oldpassword',
          newPassword: 'newpassword',
        );

        expect(result.isSuccess, isTrue);

        // Logout and login with new password
        await authService.logout();
        final loginResult = await authService.loginWithEmail(
          email: 'test@example.com',
          password: 'newpassword',
        );

        expect(loginResult.isSuccess, isTrue);
      });

      test('should return error for wrong old password', () async {
        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        final result = await authService.updatePassword(
          oldPassword: 'wrongpassword',
          newPassword: 'newpassword',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<InvalidCredentialsError>());
      });
    });

    group('authStateChanges', () {
      test('should emit user ID on login', () async {
        final states = <String?>[];
        final subscription = authService.authStateChanges.listen(states.add);

        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.last, isNotNull);
        await subscription.cancel();
      });

      test('should emit null on logout', () async {
        final states = <String?>[];
        final subscription = authService.authStateChanges.listen(states.add);

        await authService.registerWithEmail(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );

        await authService.logout();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.last, isNull);
        await subscription.cancel();
      });
    });

    group('addMockUser', () {
      test('should allow login with pre-registered user', () async {
        authService.addMockUser(
          email: 'preset@example.com',
          password: 'preset123',
          name: 'Preset User',
          userId: 'preset_user_id',
        );

        final result = await authService.loginWithEmail(
          email: 'preset@example.com',
          password: 'preset123',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, 'preset_user_id');
      });
    });
  });
}
