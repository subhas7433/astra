/// App-level constants for Astra AI
class AppConstants {
  AppConstants._();

  /// Package/Bundle identifiers
  static const String packageName = 'com.technoava.astra';

  /// Play Store URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
  static const String playStoreMarketUrl = 'market://details?id=$packageName';

  /// App Store URLs (for iOS when published)
  static const String appStoreUrl = 'https://apps.apple.com/app/id'; // Add App Store ID when available

  /// Support & Social URLs
  static const String supportEmail = 'support@astra-ai.com';
  static const String websiteUrl = 'https://www.astra-ai.com';
  static const String privacyPolicyUrl = 'https://tools.technoava.com/astra/privacy';
  static const String termsOfServiceUrl = 'https://tools.technoava.com/astra/terms';

  /// App version info
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
}
