import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../data/services/monetization_analytics.dart';

enum SubscriptionTier {
  free,
  basic,
  pro,
  premium,
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

  // TODO: Replace with your actual RevenueCat API Keys
  final String _androidApiKey = 'goog_placeholder_key';
  final String _iosApiKey = 'appl_placeholder_key';

  // Toggle this for testing
  final bool _isMockMode = true;

  final currentTier = SubscriptionTier.free.obs;
  final packages = <PaywallPackage>[].obs;
  final isLoading = true.obs;

  // Computed properties for feature gating
  bool get isPremium => currentTier.value == SubscriptionTier.premium;
  bool get isAdFree => currentTier.value != SubscriptionTier.free;
  bool get hasUnlimitedChat => currentTier.value.index >= SubscriptionTier.pro.index;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    try {
      if (!_isMockMode) {
        if (Platform.isAndroid) {
          await Purchases.configure(PurchasesConfiguration(_androidApiKey));
        } else if (Platform.isIOS) {
          await Purchases.configure(PurchasesConfiguration(_iosApiKey));
        }
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
    // Map entitlements to tiers
    if (customerInfo.entitlements.all['premium_access']?.isActive ?? false) {
      currentTier.value = SubscriptionTier.premium;
    } else if (customerInfo.entitlements.all['pro_access']?.isActive ?? false) {
      currentTier.value = SubscriptionTier.pro;
    } else if (customerInfo.entitlements.all['basic_access']?.isActive ?? false) {
      currentTier.value = SubscriptionTier.basic;
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
            identifier: 'monthly_basic',
            title: 'Basic',
            description: 'No Ads',
            priceString: '\$2.99',
            tier: SubscriptionTier.basic,
          ),
          PaywallPackage(
            identifier: 'monthly_pro',
            title: 'Pro',
            description: 'Unlimited Chat + No Ads',
            priceString: '\$5.99/mo',
            tier: SubscriptionTier.pro,
          ),
          PaywallPackage(
            identifier: 'monthly_premium',
            title: 'Premium',
            description: 'All Features + Priority Support',
            priceString: '\$9.99/mo',
            tier: SubscriptionTier.premium,
          ),
        ];
      } else {
        final offerings = await Purchases.getOfferings();
        if (offerings.current != null) {
          packages.value = offerings.current!.availablePackages.map((p) {
            // Logically map package ID to tier, or use metadata if available
            // For now, simple fallback
            var tier = SubscriptionTier.premium;
            if (p.identifier.contains('basic')) tier = SubscriptionTier.basic;
            if (p.identifier.contains('pro')) tier = SubscriptionTier.pro;

            return PaywallPackage(
              identifier: p.identifier,
              title: p.storeProduct.title,
              description: p.storeProduct.description,
              priceString: p.storeProduct.priceString,
              tier: tier,
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

  Future<void> restorePurchases() async {
    try {
      if (_isMockMode) {
        await Future.delayed(const Duration(seconds: 1));
        currentTier.value = SubscriptionTier.premium; // Restore to max in mock
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
