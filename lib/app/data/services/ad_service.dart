import 'package:get/get.dart';

class AdService extends GetxService {
  final freeMessageCount = 3.obs;

  /// Simulates showing a rewarded ad.
  /// Returns [true] if the user watched the ad and earned the reward.
  Future<bool> showRewardedAd() async {
    // Simulate ad loading delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would show the ad SDK's UI.
    // For now, we assume success.
    return true;
  }
  
  void resetCredits() {
    freeMessageCount.value = 3;
  }
  
  void decrementCredit() {
    if (freeMessageCount.value > 0) {
      freeMessageCount.value--;
    }
  }
}
