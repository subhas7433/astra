import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'monetization_analytics.dart';

class PaywallPackage {
  final String identifier;
  final String title;
  final String description;
  final String priceString;
  final Package? realPackage;

  PaywallPackage({
    required this.identifier,
    required this.title,
    required this.description,
    required this.priceString,
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

  final isPremium = false.obs;
  final packages = <PaywallPackage>[].obs;
  final isLoading = true.obs;

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
    final entitlement = customerInfo.entitlements.all['premium'];
    isPremium.value = entitlement?.isActive ?? false;
  }

  Future<void> fetchOfferings() async {
    isLoading.value = true;
    try {
      if (_isMockMode) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        packages.value = [
          PaywallPackage(
            identifier: 'monthly',
            title: 'Monthly Access',
            description: 'Unlimited chat & no ads',
            priceString: '\$4.99',
          ),
          PaywallPackage(
            identifier: 'yearly',
            title: 'Yearly Access',
            description: 'Best value: Save 50%',
            priceString: '\$29.99',
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
        isPremium.value = true;
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
        isPremium.value = true;
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
