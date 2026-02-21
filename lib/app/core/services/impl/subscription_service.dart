import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../../data/repositories/subscription_repository.dart';
import '../../../data/services/monetization_analytics.dart';

enum SubscriptionTier {
  free,
  pro,
}

class PaywallPackage {
  final String identifier;
  final String title;
  final String description;
  final String priceString;
  final SubscriptionTier tier; // Added tier
  final Package? realPackage;

  PaywallPackage({
    required this.identifier,
    required this.title,
    required this.description,
    required this.priceString,
    required this.tier,
    this.realPackage,
  });
}

class SubscriptionService extends GetxService {
  static SubscriptionService get to => Get.find();

  // RevenueCat API Keys
  final String _apiKey = 'goog_lVAzHDPmGglondnPxKJLFbIkZFt';

  // Set to false for real RevenueCat (true for UI testing without store)
  final bool _isMockMode = false;

  final currentTier = SubscriptionTier.free.obs;
  final packages = <PaywallPackage>[].obs;
  final isLoading = true.obs;

  // Computed properties for feature gating
  bool get isPro => currentTier.value == SubscriptionTier.pro;
  bool get isAdFree => currentTier.value == SubscriptionTier.pro;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    try {
      if (!_isMockMode) {
        await Purchases.configure(PurchasesConfiguration(_apiKey));
        await _checkSubscriptionStatus();
      }
      await fetchOfferings();
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    if (_isMockMode) return;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateCustomerStatus(customerInfo);
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }

  void _updateCustomerStatus(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all['pro_access']?.isActive ?? false) {
      currentTier.value = SubscriptionTier.pro;
    } else {
      currentTier.value = SubscriptionTier.free;
    }
  }

  Future<void> fetchOfferings() async {
    isLoading.value = true;
    try {
      if (_isMockMode) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        packages.value = [
          PaywallPackage(
            identifier: 'astro_pro_weekly',
            title: 'Pro Weekly',
            description: 'No Ads + 100 Credits/Day',
            priceString: '\u20B9250/week',
            tier: SubscriptionTier.pro,
          ),
          PaywallPackage(
            identifier: 'astro_pro_monthly',
            title: 'Pro Monthly',
            description: 'No Ads + 100 Credits/Day',
            priceString: '\u20B9600/month',
            tier: SubscriptionTier.pro,
          ),
        ];
      } else {
        final offerings = await Purchases.getOfferings();
        if (offerings.current != null) {
          packages.value = offerings.current!.availablePackages.map((p) {
            return PaywallPackage(
              identifier: p.identifier,
              title: p.storeProduct.title,
              description: p.storeProduct.description,
              priceString: p.storeProduct.priceString,
              tier: SubscriptionTier.pro,
              realPackage: p,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> purchasePackage(PaywallPackage package) async {
    try {
      if (_isMockMode) {
        await Future.delayed(const Duration(seconds: 2)); // Simulate purchase
        currentTier.value = package.tier; // Upgrade directly in mock
        return true;
      } else {
        if (package.realPackage != null) {
          final purchaseResult = await Purchases.purchasePackage(package.realPackage!);
          _updateCustomerStatus(purchaseResult.customerInfo);
          // Sync with backend
          try {
            final repo = Get.find<SubscriptionRepository>();
            await repo.updateSubscription(
              userId: '',
              tier: 'pro',
              platform: Platform.isAndroid ? 'android' : 'ios',
              productId: package.identifier,
              transactionId: purchaseResult.customerInfo.originalAppUserId,
            );
          } catch (e) {
            debugPrint('Error syncing subscription with backend: $e');
          }
          MonetizationAnalytics.trackSubscriptionStart(package.identifier, package.priceString);
          return true;
        }
      }
      return false;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      var errorMessage = 'Unknown error';
      
      switch (errorCode) {
        case PurchasesErrorCode.purchaseCancelledError:
          errorMessage = 'Purchase cancelled';
          break;
        case PurchasesErrorCode.paymentPendingError:
          errorMessage = 'Payment pending approval';
          break;
        case PurchasesErrorCode.networkError:
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = e.message ?? 'Purchase failed';
      }
      
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        Get.snackbar('Purchase Failed', errorMessage);
        MonetizationAnalytics.trackPurchaseError(errorMessage);
      }
      return false;
    } catch (e) {
      debugPrint('Error purchasing package: $e');
      MonetizationAnalytics.trackPurchaseError(e.toString());
      return false;
    }
  }

  Future<void> showPaywall() async {
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded('pro_access');
      if (result == PaywallResult.purchased || result == PaywallResult.restored) {
        await _checkSubscriptionStatus();
      }
    } catch (e) {
      debugPrint('Error presenting paywall: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      if (_isMockMode) {
        await Future.delayed(const Duration(seconds: 1));
        currentTier.value = SubscriptionTier.pro;
      } else {
        final customerInfo = await Purchases.restorePurchases();
        _updateCustomerStatus(customerInfo);
        MonetizationAnalytics.trackRestoreSuccess();
      }
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }
}
