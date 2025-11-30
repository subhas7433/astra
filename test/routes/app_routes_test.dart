import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/routes/app_routes.dart';

void main() {
  group('AppRoutes', () {
    group('static route constants', () {
      test('splash route should be /splash', () {
        expect(AppRoutes.splash, '/splash');
      });

      test('login route should be /login', () {
        expect(AppRoutes.login, '/login');
      });

      test('register route should be /register', () {
        expect(AppRoutes.register, '/register');
      });

      test('onboarding route should be /onboarding', () {
        expect(AppRoutes.onboarding, '/onboarding');
      });

      test('home route should be /home', () {
        expect(AppRoutes.home, '/home');
      });

      test('astrologerProfile route should contain :id parameter', () {
        expect(AppRoutes.astrologerProfile, '/astrologer/:id');
        expect(AppRoutes.astrologerProfile.contains(':id'), isTrue);
      });

      test('chat route should contain :astrologerId parameter', () {
        expect(AppRoutes.chat, '/chat/:astrologerId');
        expect(AppRoutes.chat.contains(':astrologerId'), isTrue);
      });

      test('horoscopeSelection route should be /horoscope', () {
        expect(AppRoutes.horoscopeSelection, '/horoscope');
      });

      test('horoscopeDetail route should contain :sign parameter', () {
        expect(AppRoutes.horoscopeDetail, '/horoscope/:sign');
        expect(AppRoutes.horoscopeDetail.contains(':sign'), isTrue);
      });

      test('todayBhagwan route should be /today-bhagwan', () {
        expect(AppRoutes.todayBhagwan, '/today-bhagwan');
      });

      test('todayMantra route should be /today-mantra', () {
        expect(AppRoutes.todayMantra, '/today-mantra');
      });

      test('numerology route should be /numerology', () {
        expect(AppRoutes.numerology, '/numerology');
      });

      test('settings route should be /settings', () {
        expect(AppRoutes.settings, '/settings');
      });

      test('profileEdit route should be /profile-edit', () {
        expect(AppRoutes.profileEdit, '/profile-edit');
      });

      test('language route should be /language', () {
        expect(AppRoutes.language, '/language');
      });
    });

    group('route helpers', () {
      test('astrologerProfileWithId should build correct path', () {
        expect(AppRoutes.astrologerProfileWithId('123'), '/astrologer/123');
        expect(AppRoutes.astrologerProfileWithId('abc'), '/astrologer/abc');
        expect(
          AppRoutes.astrologerProfileWithId('user_456'),
          '/astrologer/user_456',
        );
      });

      test('chatWithAstrologer should build correct path', () {
        expect(AppRoutes.chatWithAstrologer('123'), '/chat/123');
        expect(AppRoutes.chatWithAstrologer('abc'), '/chat/abc');
        expect(
          AppRoutes.chatWithAstrologer('astrologer_789'),
          '/chat/astrologer_789',
        );
      });

      test('horoscopeDetailWithSign should build correct path', () {
        expect(AppRoutes.horoscopeDetailWithSign('aries'), '/horoscope/aries');
        expect(AppRoutes.horoscopeDetailWithSign('leo'), '/horoscope/leo');
        expect(
          AppRoutes.horoscopeDetailWithSign('scorpio'),
          '/horoscope/scorpio',
        );
      });
    });

    group('route uniqueness', () {
      test('all static routes should be unique', () {
        final routes = [
          AppRoutes.splash,
          AppRoutes.login,
          AppRoutes.register,
          AppRoutes.onboarding,
          AppRoutes.home,
          AppRoutes.astrologerProfile,
          AppRoutes.chat,
          AppRoutes.horoscopeSelection,
          AppRoutes.horoscopeDetail,
          AppRoutes.todayBhagwan,
          AppRoutes.todayMantra,
          AppRoutes.numerology,
          AppRoutes.settings,
          AppRoutes.profileEdit,
          AppRoutes.language,
        ];

        final uniqueRoutes = routes.toSet();
        expect(uniqueRoutes.length, routes.length);
      });

      test('all routes should start with /', () {
        final routes = [
          AppRoutes.splash,
          AppRoutes.login,
          AppRoutes.register,
          AppRoutes.onboarding,
          AppRoutes.home,
          AppRoutes.astrologerProfile,
          AppRoutes.chat,
          AppRoutes.horoscopeSelection,
          AppRoutes.horoscopeDetail,
          AppRoutes.todayBhagwan,
          AppRoutes.todayMantra,
          AppRoutes.numerology,
          AppRoutes.settings,
          AppRoutes.profileEdit,
          AppRoutes.language,
        ];

        for (final route in routes) {
          expect(route.startsWith('/'), isTrue,
              reason: 'Route "$route" should start with /');
        }
      });
    });
  });
}
