import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../core/services/interfaces/i_auth_service.dart';
import '../core/utils/app_logger.dart';
import 'base_controller.dart';

class UserController extends BaseController {
  static const String _tag = 'UserController';
  final UserRepository _userRepository = Get.find<UserRepository>();
  final IAuthService _authService = Get.find<IAuthService>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);

  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _authService.authStateChanges.listen((userId) {
      if (userId != null) {
        loadProfile(userId);
      } else {
        user.value = null;
      }
    });
    
    // Initial check
    if (_authService.currentUserId != null) {
      loadProfile(_authService.currentUserId!);
    }
  }

  Future<void> loadProfile(String userId) async {
    AppLogger.info('Loading user profile: $userId', tag: _tag);
    
    await executeWithState(
      operation: () => _userRepository.getUser(userId),
      onSuccess: (userData) {
        user.value = userData;
        AppLogger.info('User profile loaded: ${userData.fullName}', tag: _tag);
      },
      onError: (error) {
        AppLogger.error('Failed to load profile', error: error, tag: _tag);
      },
    );
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    AppLogger.info('Updating user profile', tag: _tag);
    
    await executeWithState(
      operation: () => _userRepository.saveUser(updatedUser),
      onSuccess: (userData) {
        user.value = userData;
        Get.back(); // Close edit screen
        Get.snackbar('Success', 'Profile updated successfully');
      },
      onError: (error) {
        Get.snackbar('Error', error.message);
      },
    );
  }
}
