/// Centralized asset path constants for Astro GPT
/// All asset paths should be defined here to avoid hardcoded strings
/// and enable easy asset management.
abstract class AppAssets {
  AppAssets._();

  // Base paths
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _zodiac = 'assets/icons/zodiac';

  // Images
  static const String logo = '$_images/logo.png';
  static const String placeholder = '$_images/placeholder.png';

  // General Icons
  static const String iconSettings = '$_icons/settings.svg';
  static const String iconBack = '$_icons/back.svg';
  static const String iconSend = '$_icons/send.svg';
  static const String iconHeart = '$_icons/heart.svg';
  static const String iconHeartFilled = '$_icons/heart_filled.svg';
  static const String iconShare = '$_icons/share.svg';
  static const String iconOm = '$_icons/om.svg';

  // Feature Icons
  static const String iconHoroscope = '$_icons/horoscope.svg';
  static const String iconTodayGod = '$_icons/today_god.svg';
  static const String iconNumerology = '$_icons/numerology.svg';
  static const String iconHistory = '$_icons/history.svg';
  static const String iconMantra = '$_icons/mantra.svg';

  // Navigation Icons
  static const String iconHome = '$_icons/home.svg';
  static const String iconChat = '$_icons/chat.svg';
  static const String iconProfile = '$_icons/profile.svg';

  // Zodiac icon helper
  /// Returns the path to a zodiac sign icon
  /// [sign] should be lowercase (e.g., 'aries', 'taurus')
  static String zodiacIcon(String sign) => '$_zodiac/${sign.toLowerCase()}.svg';
}
