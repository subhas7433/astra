import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/auth_binding.dart';
import '../bindings/splash_binding.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/astrologer_profile/bindings/astrologer_profile_binding.dart';
import '../modules/astrologer_profile/views/astrologer_profile_view.dart';
import '../modules/astrologer/bindings/astrologer_list_binding.dart';
import '../modules/astrologer/views/astrologer_list_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_screen.dart';
import '../modules/horoscope/bindings/zodiac_picker_binding.dart';
import '../modules/horoscope/views/zodiac_picker_screen.dart';
import '../modules/horoscope/bindings/horoscope_detail_binding.dart';
import '../modules/horoscope/views/horoscope_detail_screen.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/daily_content/bindings/today_bhagwan_binding.dart';
import '../modules/daily_content/views/today_bhagwan_screen.dart';
import '../modules/daily_content/bindings/today_mantra_binding.dart';
import '../modules/daily_content/views/today_mantra_screen.dart';
import '../modules/daily_content/bindings/numerology_binding.dart';
import '../modules/daily_content/views/numerology_screen.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/controllers/language_controller.dart';
import '../modules/settings/views/favorites_screen.dart';
import '../modules/settings/views/language_screen.dart';
import '../modules/settings/views/profile_edit_screen.dart';
import '../modules/settings/views/settings_screen.dart';
import '../modules/settings/views/about_screen.dart';
import '../modules/settings/views/feedback_screen.dart';
import '../modules/settings/views/privacy_screen.dart';
import '../modules/settings/views/terms_screen.dart';
import '../modules/settings/views/paywall_screen.dart';
import 'app_routes.dart';

/// GetX page definitions for app navigation.
///
/// Defines all routes, their pages, bindings, and transitions.
///
/// Usage:
/// ```dart
/// GetMaterialApp(
///   initialRoute: AppPages.initial,
///   getPages: AppPages.pages,
/// )
/// ```
class AppPages {
  AppPages._();

  /// Initial route when app starts
  static const HOME = '/home';
  static const ASTROLOGER_PROFILE = '/astrologer-profile';
  static const String initial = AppRoutes.home;

  /// Default page transition
  static const Transition defaultTransition = Transition.fadeIn;

  /// Default transition duration
  static const Duration transitionDuration = Duration(milliseconds: 250);

  /// All route definitions
  static final List<GetPage> pages = [
    // ============ Auth Flow ============

    /// Splash screen - app entry point
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// Login screen
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),

    /// Registration screen
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    /// Onboarding (stub)
    GetPage(
      name: AppRoutes.onboarding,
      page: () => _buildStubPage('Onboarding', Icons.start),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),

    // ============ Main App ============

    /// Home dashboard
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: transitionDuration,
    ),

    // ============ Astrologer ============

    /// Astrologer List
    GetPage(
      name: AppRoutes.astrologerList,
      page: () => const AstrologerListView(),
      binding: AstrologerListBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    /// Astrologer Profile
    GetPage(
      name: AppRoutes.astrologerProfile,
      page: () => const AstrologerProfileView(),
      binding: AstrologerProfileBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    /// Chat with astrologer (parameterized)
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    // ============ Horoscope ============

    /// Zodiac selection (stub)


    /// Horoscope detail
    GetPage(
      name: AppRoutes.horoscopeDetail,
      page: () => const HoroscopeDetailScreen(),
      binding: HoroscopeDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    // ============ Daily Content ============

    /// Today's Bhagwan
    GetPage(
      name: AppRoutes.todayBhagwan,
      page: () => const TodayBhagwanScreen(),
      binding: TodayBhagwanBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),

    /// Today's Mantra
    GetPage(
      name: AppRoutes.todayMantra,
      page: () => const TodayMantraScreen(),
      binding: TodayMantraBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),

    /// Numerology
    GetPage(
      name: AppRoutes.numerology,
      page: () => const NumerologyScreen(),
      binding: NumerologyBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),

    // ============ Settings ============

    /// Settings main screen
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LanguageController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const ProfileEditScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.privacy,
      page: () => const PrivacyScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.terms,
      page: () => const TermsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: transitionDuration,
    ),

    GetPage(
      name: AppRoutes.paywall,
      page: () => const PaywallScreen(),
      transition: Transition.downToUp, // Modal-like transition
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: AppRoutes.horoscopeSelection,
      page: () => const ZodiacPickerScreen(),
      binding: ZodiacPickerBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
  ];

  /// Build a stub page for routes not yet implemented.
  ///
  /// Shows route name, icon, current route path, and any parameters.
  static Widget _buildStubPage(String name, IconData icon) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppDimensions.lg),

              // Page Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppDimensions.xs),

              // Coming Soon
              Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.lg),

              // Current Route
              Container(
                padding: EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Column(
                  children: [
                    Text(
                      'Route: ${Get.currentRoute}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (Get.parameters.isNotEmpty) ...[
                      SizedBox(height: AppDimensions.xs),
                      Text(
                        'Params: ${Get.parameters}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.xl),

              // Back Button (if can go back)
              if (Get.previousRoute.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
