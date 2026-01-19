import 'package:get/get.dart';
import '../../../core/services/impl/subscription_service.dart';

class PaywallController extends GetxController {
  final _subscriptionService = Get.find<SubscriptionService>();

  RxList<PaywallPackage> get packages => _subscriptionService.packages;
  RxBool get isLoading => _subscriptionService.isLoading;
  bool get isPremium => _subscriptionService.isPremium;

  final isPurchaseLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Refresh offerings when entering screen to ensure latest prices
    _subscriptionService.fetchOfferings();
  }

  Future<void> purchase(PaywallPackage package) async {
    if (isPurchaseLoading.value) return;

    isPurchaseLoading.value = true;
    final success = await _subscriptionService.purchasePackage(package);
    isPurchaseLoading.value = false;

    if (success) {
      Get.back(); // Close paywall on success
      Get.snackbar(
        'Welcome to Premium!',
        'Thank you for subscribing.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> restore() async {
    if (isPurchaseLoading.value) return;

    isPurchaseLoading.value = true;
    await _subscriptionService.restorePurchases();
    isPurchaseLoading.value = false;
    
    // Feedback is handled by service or we can check premium status
    if (isPremium) {
      Get.back();
      Get.snackbar('Success', 'Purchases restored.');
    } else {
      Get.snackbar('Notice', 'No active subscriptions found to restore.');
    }
  }
}
