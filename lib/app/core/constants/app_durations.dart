/// Centralized animation and duration constants for Astro GPT
/// All durations used for animations, transitions, and delays
/// should be defined here for consistent timing.
abstract class AppDurations {
  AppDurations._();

  // General animation speeds
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);

  // Specific use cases
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration cardTap = Duration(milliseconds: 150);
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration fadeIn = Duration(milliseconds: 200);

  // Delays
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration debounceSearch = Duration(milliseconds: 300);
  static const Duration tooltipWait = Duration(milliseconds: 500);
}
