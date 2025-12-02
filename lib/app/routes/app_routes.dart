/// Route name constants for type-safe navigation.
///
/// Usage:
/// ```dart
/// Get.toNamed(AppRoutes.home);
/// Get.offAllNamed(AppRoutes.login);
/// Get.toNamed(AppRoutes.astrologerProfileWithId('123'));
/// ```
abstract class AppRoutes {
  AppRoutes._();

  // ============ Auth Flow ============
  /// Splash screen - app entry point
  static const String splash = '/splash';

  /// Login screen
  static const String login = '/login';

  /// Registration screen
  static const String register = '/register';

  /// Onboarding screen (first-time users)
  static const String onboarding = '/onboarding';

  // ============ Main App ============
  /// Home dashboard
  static const String home = '/home';

  /// Astrologer profile (parameterized)
  static const String astrologerProfile = '/astrologer/:id';

  /// Chat with astrologer (parameterized)
  static const chat = '/chat/:astrologerId';
  static const horoscope = '/horoscope';

  /// Astrologer list screen
  static const String astrologerList = '/astrologer-list';

  // ============ Horoscope ============
  /// Zodiac sign selection screen
  static const String horoscopeSelection = '/horoscope';

  /// Horoscope detail for a specific sign (parameterized)
  static const String horoscopeDetail = '/horoscope/:sign';

  // ============ Daily Content ============
  /// Today's Bhagwan screen
  static const String todayBhagwan = '/today-bhagwan';

  /// Today's Mantra screen
  static const String todayMantra = '/today-mantra';

  /// Numerology screen
  static const String numerology = '/numerology';

  // ============ Settings ============
  /// Settings main screen
  static const settings = '/settings';
  static const language = '/settings/language';
  static const profileEdit = '/settings/profile-edit';
  static const favorites = '/settings/favorites';
  static const about = '/settings/about';
  static const feedback = '/settings/feedback';
  static const privacy = '/settings/privacy';
  static const terms = '/settings/terms';
  static const paywall = '/settings/paywall';

  // ============ Route Helpers ============
  // For parameterized routes, use these helpers to build correct paths

  /// Build astrologer profile route with ID
  /// Example: `/astrologer/abc123`
  static String astrologerProfileWithId(String id) => '/astrologer/$id';

  /// Build chat route with astrologer ID
  /// Example: `/chat/abc123`
  static String chatWithAstrologer(String astrologerId) =>
      '/chat/$astrologerId';

  /// Build horoscope detail route with zodiac sign
  /// Example: `/horoscope/aries`
  static String horoscopeDetailWithSign(String sign) => '/horoscope/$sign';
}
