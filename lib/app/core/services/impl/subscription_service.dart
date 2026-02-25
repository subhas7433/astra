import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../../data/repositories/subscription_repository.dart';
import '../../../data/services/monetization_analytics.dart';
import '../../constants/app_constants.dart';
import '../../services/interfaces/i_auth_service.dart';

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

  // RevenueCat
  static const String _apiKey = AppConstants.revenueCatApiKey;

  // Set to false for real RevenueCat (true for UI testing without store)
  final bool _isMockMode = false;

  final currentTier = SubscriptionTier.free.obs;
  final packages = <PaywallPackage>[].obs;
  final isLoading = true.obs;
  final chatCredits = 0.obs;

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
        final authService = Get.find<IAuthService>();
        
        // Pass the appUserID during configuration if we already have it
        if (authService.currentUserId != null && authService.currentUserId!.isNotEmpty) {
           await Purchases.configure(
             PurchasesConfiguration(_apiKey)..appUserID = authService.currentUserId,
           );
        } else {
           await Purchases.configure(PurchasesConfiguration(_apiKey));
        }

        // Listen for auth state changes so RevenueCat always knows the active user
        
        // Initial setup if already logged in
        if (authService.currentUserId != null && authService.currentUserId!.isNotEmpty) {
          await Purchases.logIn(authService.currentUserId!);
        }

        // Listen for future changes (including the async resolve on app startup)
        authService.authStateChanges.listen((userId) async {
          if (userId != null && userId.isNotEmpty) {
            await Purchases.logIn(userId);
          } else {
            await Purchases.logOut();
          }
          await _checkSubscriptionStatus();
          await fetchCredits();
        });

        await _checkSubscriptionStatus();
      }
      await fetchOfferings();
      await fetchCredits();
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  Future<void> fetchCredits() async {
    try {
      // Find current user id from AuthService mapping (assuming it's available)
      final authService = Get.find<IAuthService>();
      final userId = authService.currentUserId;
      if (userId != null && userId.isNotEmpty) {
        final repo = Get.find<SubscriptionRepository>();
        final result = await repo.getSubscription(userId);
        if (result.isSuccess) {
          final data = result.valueOrNull;
          if (data != null) {
            chatCredits.value = data.chatCredits;
            
            // Sync tier from backend (source of truth)
            currentTier.value = data.isPro
                ? SubscriptionTier.pro
                : SubscriptionTier.free;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching credits: $e');
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
    if (customerInfo.entitlements.all[AppConstants.revenueCatEntitlementId]?.isActive ?? false) {
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
          // Backend is updated via RevenueCat webhook (server-to-server)
          // Frontend only reads subscription state, never writes it
          await fetchCredits();
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
      final result = await RevenueCatUI.presentPaywallIfNeeded(AppConstants.revenueCatEntitlementId);
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
