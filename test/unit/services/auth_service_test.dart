import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:astra/app/core/services/impl/appwrite_auth_service.dart';
import 'package:astra/app/data/providers/appwrite_client_provider.dart';
import 'package:astra/app/core/result/result.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([AppwriteClientProvider, Account])
void main() {
  late AppwriteAuthService authService;
  late MockAppwriteClientProvider mockClientProvider;
  late MockAccount mockAccount;

  setUp(() {
    mockClientProvider = MockAppwriteClientProvider();
    mockAccount = MockAccount();

    when(mockClientProvider.account).thenReturn(mockAccount);
    authService = AppwriteAuthService(mockClientProvider);
  });

  group('AppwriteAuthService', () {
    const email = 'test@example.com';
    const password = 'password123';
    const userId = 'user123';

    test('loginWithEmail returns success when Appwrite login succeeds', () async {
      // Arrange
      final mockSession = models.Session(
        $id: 'sessionId',
        $createdAt: '',
        userId: userId,
        expire: '',
        provider: '',
        providerUid: '',
        providerAccessToken: '',
        providerAccessTokenExpiry: '',
        providerRefreshToken: '',
        ip: '',
        osCode: '',
        osName: '',
        osVersion: '',
        clientType: '',
        clientCode: '',
        clientName: '',
        clientVersion: '',
        clientEngine: '',
        clientEngineVersion: '',
        deviceName: '',
        deviceBrand: '',
        deviceModel: '',
        countryCode: '',
        countryName: '',
        current: true,
      );

      final mockUser = models.User(
        $id: userId,
        $createdAt: '',
        $updatedAt: '',
        name: 'Test User',
        registration: '',
        status: true,
        labels: [],
        passwordUpdate: '',
        email: email,
        phone: '',
        emailVerification: true,
        phoneVerification: true,
        prefs: models.Preferences(data: {}),
        accessedAt: '',
        mfa: false,
        targets: [],
      );

      when(mockAccount.createEmailPasswordSession(email: email, password: password))
          .thenAnswer((_) async => mockSession);
      when(mockAccount.get()).thenAnswer((_) async => mockUser);

      // Act
      final result = await authService.loginWithEmail(email: email, password: password);

      // Assert
      expect(result.isSuccess, true);
      result.fold(
        onSuccess: (id) => expect(id, userId),
        onFailure: (_) => fail('Should succeed'),
      );
      verify(mockAccount.createEmailPasswordSession(email: email, password: password)).called(1);
    });

    test('loginWithEmail returns failure when Appwrite throws exception', () async {
      // Arrange
      when(mockAccount.createEmailPasswordSession(email: email, password: password))
          .thenThrow(AppwriteException('Invalid credentials', 401));

      // Act
      final result = await authService.loginWithEmail(email: email, password: password);

      // Assert
      expect(result.isFailure, true);
      verify(mockAccount.createEmailPasswordSession(email: email, password: password)).called(1);
    });

    test('logout deletes session', () async {
        // Arrange
        when(mockAccount.deleteSession(sessionId: 'current'))
            .thenAnswer((_) async => {});
            
        // Act
        final result = await authService.logout();

        // Assert
        expect(result.isSuccess, true);
        verify(mockAccount.deleteSession(sessionId: 'current')).called(1);
    });
  });
}
