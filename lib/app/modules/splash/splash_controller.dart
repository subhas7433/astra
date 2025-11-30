import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../core/services/interfaces/i_auth_service.dart';
import '../../core/utils/app_logger.dart';
import '../../routes/app_routes.dart';

/// Splash screen controller.
///
/// Responsibilities:
/// - Check if user is authenticated
/// - Navigate to appropriate screen (Home or Login)
/// - Handle initialization errors gracefully
class SplashController extends BaseController {
  static const String _tag = 'SplashController';

  @override
  String get tag => _tag;

  /// Auth service for checking session
  late final IAuthService _authService;

  /// Minimum splash display duration for branding
  static const Duration _splashDuration = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<IAuthService>();
  }

  @override
  void onReady() {
    super.onReady();
    _checkAuthAndNavigate();
  }

  /// Check authentication status and navigate accordingly.
  Future<void> _checkAuthAndNavigate() async {
    AppLogger.info('Checking authentication status...', tag: _tag);

    // Show splash for minimum duration (for branding)
    await Future.delayed(_splashDuration);

    // Check if user has valid session
    final result = await _authService.checkSession();

    result.fold(
      onSuccess: (isAuthenticated) {
        if (isAuthenticated) {
          AppLogger.info('User authenticated, navigating to home', tag: _tag);
          Get.offAllNamed(AppRoutes.home);
        } else {
          AppLogger.info('User not authenticated, navigating to login', tag: _tag);
          Get.offAllNamed(AppRoutes.login);
        }
      },
      onFailure: (error) {
        AppLogger.warning(
          'Auth check failed: ${error.message}, defaulting to login',
          tag: _tag,
        );
        // On error, default to login screen
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
