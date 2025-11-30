# Week 6: Monetization - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 6 Goal
Complete monetization system with AdMob ads, RevenueCat subscriptions, and premium features

### What We're Building
- AdMob integration (banner, interstitial, rewarded)
- Rewarded ads for free chat credits
- RevenueCat subscription management
- Three subscription tiers (Basic, Pro, Premium)
- Premium feature gating
- Paywall/subscription screen
- Remove Ads purchase flow
- Receipt validation

### What We're NOT Building
- Consumable IAP (one-time purchases)
- Promotional codes system
- Affiliate/referral system
- Ad mediation (single network)

### Prerequisites (from Week 1-5)
- [x] AdModal widget (Week 3)
- [x] Settings screen with "Remove Ads"
- [x] Chat free credit system
- [x] User authentication

---

## Session 1: AdMob Setup & Configuration (4 hours)

### Objectives
1. Configure AdMob account and app IDs
2. Set up google_mobile_ads package
3. Create AdService singleton
4. Implement ad initialization
5. Configure test ad units

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| AdMob configuration | App IDs, Ad unit IDs |
| `AdService` | Singleton ad manager |
| Initialization flow | Init on app start |
| Test mode | Test ad units configured |
| Platform setup | iOS/Android config files |

### Module Structure
```
lib/app/core/services/
├── ad_service.dart
├── subscription_service.dart
└── premium_service.dart

lib/app/modules/premium/
├── bindings/
│   └── premium_binding.dart
├── controllers/
│   ├── ad_controller.dart
│   └── subscription_controller.dart
├── views/
│   ├── paywall_screen.dart
│   └── subscription_success_screen.dart
└── widgets/
    ├── banner_ad_widget.dart
    ├── subscription_card.dart
    └── feature_comparison.dart
```

### Platform Configuration

**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
</array>
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AdMob account setup | 30 min | App + ad units |
| Package configuration | 30 min | pubspec + imports |
| Platform files | 40 min | Android + iOS config |
| AdService class | 60 min | Singleton service |
| Initialization flow | 40 min | Init on app start |
| Test mode setup | 40 min | Test ad IDs |

### AdService Structure
```dart
class AdService extends GetxService {
  static AdService get to => Get.find();

  // Ad unit IDs (from environment)
  late final String bannerAdUnitId;
  late final String interstitialAdUnitId;
  late final String rewardedAdUnitId;

  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // State
  final isBannerLoaded = false.obs;
  final isInterstitialReady = false.obs;
  final isRewardedReady = false.obs;

  // Methods
  Future<void> initialize();
  Future<void> loadBannerAd();
  Future<void> loadInterstitialAd();
  Future<void> loadRewardedAd();
  void showInterstitial({VoidCallback? onComplete});
  void showRewarded({required Function(int) onReward});
  void dispose();
}
```

### Acceptance Criteria
- [ ] AdMob initializes without errors
- [ ] Test ads load successfully
- [ ] Ad unit IDs configured per environment
- [ ] No ads shown to premium users
- [ ] Proper error handling for ad failures

---

## Session 2: Banner & Interstitial Ads (4 hours)

### Objectives
1. Create BannerAdWidget component
2. Implement banner ad placement
3. Build interstitial ad flow
4. Add ad frequency capping
5. Handle ad lifecycle properly

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `BannerAdWidget` | Reusable banner component |
| Banner placements | Home, Horoscope screens |
| Interstitial flow | Between screen transitions |
| Frequency capping | Max 1 interstitial per 3 min |
| Lifecycle handling | Pause/resume with app |

### Banner Ad Placement (from design)
```
Home Screen:
┌─────────────────────────────────┐
│ [App Content...]                │
│                                 │
│                                 │
├─────────────────────────────────┤
│ [     Banner Ad (320x50)      ] │  Bottom
└─────────────────────────────────┘

Horoscope Detail:
┌─────────────────────────────────┐
│ [Horoscope Header]              │
│ [Time Period Tabs]              │
├─────────────────────────────────┤
│ [     Banner Ad (320x50)      ] │  Below tabs
├─────────────────────────────────┤
│ [Category Cards...]             │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| BannerAdWidget | 50 min | Reusable component |
| Banner loading logic | 35 min | Load + error handling |
| Home banner placement | 30 min | Bottom position |
| Horoscope banner | 30 min | Below tabs |
| Interstitial loading | 40 min | Preload logic |
| Frequency capping | 35 min | Time-based limit |

### BannerAdWidget
```dart
class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner, // 320x50
  });
}

// Usage
BannerAdWidget() // Standard banner
BannerAdWidget(adSize: AdSize.largeBanner) // 320x100
```

### Interstitial Frequency Capping
```dart
class AdService {
  DateTime? _lastInterstitialShown;
  static const _interstitialCooldown = Duration(minutes: 3);

  bool get canShowInterstitial {
    if (_lastInterstitialShown == null) return true;
    return DateTime.now().difference(_lastInterstitialShown!) > _interstitialCooldown;
  }

  void showInterstitial({VoidCallback? onComplete}) {
    if (!canShowInterstitial) {
      onComplete?.call();
      return;
    }
    // Show ad...
    _lastInterstitialShown = DateTime.now();
  }
}
```

### Acceptance Criteria
- [ ] Banner ads display correctly sized
- [ ] Banner hides for premium users
- [ ] Interstitial shows between screens
- [ ] Frequency capping works
- [ ] Ads pause when app backgrounds
- [ ] No crashes on ad errors

---

## Session 3: Rewarded Ads Integration (4 hours)

### Objectives
1. Implement rewarded ad loading
2. Create reward callback system
3. Integrate with chat free credits
4. Build reward confirmation UI
5. Handle reward validation

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| Rewarded ad loading | Preload on demand |
| Reward callbacks | Credit system integration |
| AdModal integration | "Watch Ad" button flow |
| Reward confirmation | Success toast/animation |
| Retry on failure | Reload if ad fails |

### Rewarded Ad Flow
```
1. User runs out of free chats
2. AdModal shows "Watch Ad for 3 Free Chats"
3. User taps "Watch Video Ad"
4. Rewarded ad plays (15-30 sec)
5. User completes ad (or closes early)
6. If completed: Add 3 credits, show success
7. If skipped: No reward, show message
8. Preload next rewarded ad
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Rewarded ad loading | 45 min | Preload logic |
| Reward callback | 40 min | onReward handler |
| Chat credit integration | 45 min | Add credits on reward |
| Success animation | 35 min | Reward received UI |
| Failure handling | 30 min | Retry + error UI |
| Ad preloading | 25 min | Load next ad |

### Reward Integration with Chat
```dart
// In AdModal
void _onWatchAdPressed() async {
  final adService = AdService.to;

  if (!adService.isRewardedReady.value) {
    Get.snackbar('Ad Not Ready', 'Please try again in a moment');
    await adService.loadRewardedAd();
    return;
  }

  adService.showRewarded(
    onReward: (amount) {
      // Add credits
      Get.find<ChatController>().addFreeCredits(3);
      Get.back(); // Close modal
      _showRewardSuccess();
    },
  );
}

void _showRewardSuccess() {
  Get.snackbar(
    'Reward Received!',
    'You got 3 free chat messages',
    icon: Icon(Icons.celebration),
  );
}
```

### Acceptance Criteria
- [ ] Rewarded ad plays fully
- [ ] Credits added only on completion
- [ ] Early close gives no reward
- [ ] Success feedback shows
- [ ] Next ad preloads automatically
- [ ] Fallback if no ad available

---

## Session 4: RevenueCat Setup & Subscriptions (4 hours)

### Objectives
1. Configure RevenueCat account
2. Set up purchases_flutter package
3. Create SubscriptionService
4. Define subscription tiers
5. Implement purchase flow

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| RevenueCat config | Project + API keys |
| `SubscriptionService` | Purchase management |
| Subscription tiers | Basic, Pro, Premium |
| Purchase flow | Buy subscription |
| Restore purchases | Restore on new device |

### Subscription Tiers
```dart
enum SubscriptionTier {
  free,    // Default - ads, limited features
  basic,   // $2.99/mo - No ads
  pro,     // $5.99/mo - No ads + unlimited chat
  premium, // $9.99/mo - Everything + priority support
}

class SubscriptionTiers {
  static const basic = SubscriptionTier(
    id: 'astro_basic_monthly',
    name: 'Basic',
    price: '\$2.99',
    period: 'month',
    features: ['No advertisements', 'Basic horoscopes'],
  );

  static const pro = SubscriptionTier(
    id: 'astro_pro_monthly',
    name: 'Pro',
    price: '\$5.99',
    period: 'month',
    features: ['Everything in Basic', 'Unlimited AI chat', 'Detailed horoscopes'],
  );

  static const premium = SubscriptionTier(
    id: 'astro_premium_monthly',
    name: 'Premium',
    price: '\$9.99',
    period: 'month',
    features: ['Everything in Pro', 'Priority support', 'Exclusive content'],
  );
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| RevenueCat setup | 45 min | Account + products |
| Package configuration | 30 min | purchases_flutter |
| SubscriptionService | 60 min | Full service |
| Purchase flow | 45 min | Buy subscription |
| Restore purchases | 30 min | Restore flow |
| Error handling | 30 min | Payment failures |

### SubscriptionService Structure
```dart
class SubscriptionService extends GetxService {
  static SubscriptionService get to => Get.find();

  final currentTier = SubscriptionTier.free.obs;
  final isSubscribed = false.obs;
  final offerings = Rxn<Offerings>();

  Future<void> initialize();
  Future<void> fetchOfferings();
  Future<bool> purchasePackage(Package package);
  Future<void> restorePurchases();
  bool hasAccess(String entitlement);

  // Entitlement checks
  bool get isAdFree => currentTier.value != SubscriptionTier.free;
  bool get hasUnlimitedChat => currentTier.value.index >= SubscriptionTier.pro.index;
  bool get isPremium => currentTier.value == SubscriptionTier.premium;
}
```

### Acceptance Criteria
- [ ] RevenueCat SDK initializes
- [ ] Offerings fetch successfully
- [ ] Purchase completes on sandbox
- [ ] Subscription status updates
- [ ] Restore works on new device
- [ ] Receipt validation works

---

## Session 5: Paywall Screen & Premium Features (4 hours)

### Objectives
1. Build Paywall/Subscription screen
2. Create feature comparison table
3. Implement subscription cards
4. Add premium feature gating
5. Handle subscription state changes

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `PaywallScreen` | Subscription selection |
| `SubscriptionCard` | Tier display card |
| `FeatureComparison` | Feature table |
| Feature gating | Check before access |
| `PremiumService` | Centralized gating |

### Paywall Screen Layout
```
┌─────────────────────────────────┐
│ ←  Go Premium                   │
├─────────────────────────────────┤
│                                 │
│  🌟 Unlock Premium Features     │
│                                 │
│  Choose your plan:              │
│                                 │
│  ┌─────────────────────────┐   │
│  │ BASIC         $2.99/mo  │   │
│  │ • No ads                │   │
│  │ • Basic horoscopes      │   │
│  │ [Select]                │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ PRO ⭐        $5.99/mo  │   │  POPULAR
│  │ • Everything in Basic   │   │
│  │ • Unlimited AI chat     │   │
│  │ • Detailed horoscopes   │   │
│  │ [Select]                │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ PREMIUM       $9.99/mo  │   │
│  │ • Everything in Pro     │   │
│  │ • Priority support      │   │
│  │ • Exclusive content     │   │
│  │ [Select]                │   │
│  └─────────────────────────┘   │
│                                 │
│  [Restore Purchases]            │
│                                 │
│  Terms • Privacy                │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| PaywallScreen | 60 min | Full screen |
| SubscriptionCard | 45 min | Tier card widget |
| FeatureComparison | 40 min | Comparison table |
| PremiumService | 35 min | Feature gating |
| Gating integration | 40 min | Check in features |
| Success screen | 30 min | Purchase success |

### Premium Feature Gating
```dart
class PremiumService extends GetxService {
  static PremiumService get to => Get.find();

  // Feature checks
  bool canAccessFeature(PremiumFeature feature) {
    final tier = SubscriptionService.to.currentTier.value;

    switch (feature) {
      case PremiumFeature.noAds:
        return tier.index >= SubscriptionTier.basic.index;
      case PremiumFeature.unlimitedChat:
        return tier.index >= SubscriptionTier.pro.index;
      case PremiumFeature.prioritySupport:
        return tier == SubscriptionTier.premium;
      case PremiumFeature.exclusiveContent:
        return tier == SubscriptionTier.premium;
    }
  }

  // Gate a feature with paywall
  void gateFeature(PremiumFeature feature, VoidCallback onAccess) {
    if (canAccessFeature(feature)) {
      onAccess();
    } else {
      Get.to(() => PaywallScreen(highlightFeature: feature));
    }
  }
}

enum PremiumFeature {
  noAds,
  unlimitedChat,
  prioritySupport,
  exclusiveContent,
}
```

### Usage in App
```dart
// In ChatController
void sendMessage(String text) {
  if (!PremiumService.to.canAccessFeature(PremiumFeature.unlimitedChat)) {
    if (freeCredits.value <= 0) {
      // Show ad modal or paywall
      Get.dialog(AdModal());
      return;
    }
  }
  // Send message...
}

// In HomeScreen - hide banner for premium
Obx(() => PremiumService.to.canAccessFeature(PremiumFeature.noAds)
    ? SizedBox.shrink()
    : BannerAdWidget()
)
```

### Acceptance Criteria
- [ ] Paywall shows all tiers
- [ ] Popular tier highlighted
- [ ] Purchase flow completes
- [ ] Features properly gated
- [ ] Ads hidden for subscribers
- [ ] Restore purchases works

---

## Session 6: Testing & Analytics (4 hours)

### Objectives
1. Test all purchase flows (sandbox)
2. Implement subscription analytics
3. Add A/B testing hooks
4. Handle edge cases
5. Final integration testing

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| Sandbox testing | All purchase flows |
| Analytics events | Purchase tracking |
| Edge case handling | Failures, cancels |
| Receipt validation | Server-side check |
| Widget tests | Premium components |

### Analytics Events
```dart
// Track these events
class MonetizationAnalytics {
  static void trackPaywallView(String source);
  static void trackSubscriptionStart(String tier);
  static void trackSubscriptionCancel(String tier);
  static void trackAdImpression(String adType);
  static void trackAdClick(String adType);
  static void trackRewardedComplete();
  static void trackPurchaseError(String error);
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Sandbox testing | 60 min | All flows verified |
| Analytics setup | 45 min | Event tracking |
| Edge case handling | 40 min | Error states |
| Receipt validation | 35 min | Server check |
| Widget tests | 50 min | Component tests |
| Integration tests | 50 min | Full flow tests |

### Edge Cases to Handle
```dart
// 1. Purchase pending (needs parent approval)
// 2. Purchase failed (card declined)
// 3. Purchase cancelled by user
// 4. Network error during purchase
// 5. Already subscribed (restore instead)
// 6. Subscription expired
// 7. Subscription downgraded
// 8. Refund processed
```

### Error Handling
```dart
Future<bool> purchasePackage(Package package) async {
  try {
    final result = await Purchases.purchasePackage(package);
    // Success
    return true;
  } on PurchasesErrorCode catch (e) {
    switch (e) {
      case PurchasesErrorCode.purchaseCancelledError:
        // User cancelled - no message needed
        break;
      case PurchasesErrorCode.paymentPendingError:
        Get.snackbar('Purchase Pending', 'Ask your parent to approve');
        break;
      case PurchasesErrorCode.networkError:
        Get.snackbar('Network Error', 'Please check your connection');
        break;
      default:
        Get.snackbar('Purchase Failed', 'Please try again');
    }
    return false;
  }
}
```

### Acceptance Criteria
- [ ] All purchase flows work in sandbox
- [ ] Analytics events fire correctly
- [ ] Edge cases handled gracefully
- [ ] No crashes on payment errors
- [ ] Widget tests pass
- [ ] Integration tests pass

---

## Week 6 Success Metrics

| Metric | Target |
|--------|--------|
| Ad load success rate | >95% |
| Purchase completion rate | Track baseline |
| Rewarded ad completion | >70% |
| Crash rate (ads) | 0% |
| Revenue tracking | Accurate |

## Ad Unit IDs (Configure in .env)

```bash
# Development (Test IDs)
ADMOB_BANNER_ID_ANDROID=ca-app-pub-3940256099942544/6300978111
ADMOB_BANNER_ID_IOS=ca-app-pub-3940256099942544/2934735716
ADMOB_INTERSTITIAL_ID_ANDROID=ca-app-pub-3940256099942544/1033173712
ADMOB_INTERSTITIAL_ID_IOS=ca-app-pub-3940256099942544/4411468910
ADMOB_REWARDED_ID_ANDROID=ca-app-pub-3940256099942544/5224354917
ADMOB_REWARDED_ID_IOS=ca-app-pub-3940256099942544/1712485313

# Production (Replace with real IDs)
# ADMOB_BANNER_ID_ANDROID=ca-app-pub-XXXX/YYYY
# ...
```

## RevenueCat Configuration

```dart
// lib/app/core/constants/revenue_cat_constants.dart
class RevenueCatConstants {
  static const apiKeyAndroid = 'your_android_api_key';
  static const apiKeyIOS = 'your_ios_api_key';

  // Entitlements
  static const entitlementBasic = 'basic';
  static const entitlementPro = 'pro';
  static const entitlementPremium = 'premium';

  // Product IDs
  static const basicMonthly = 'astro_basic_monthly';
  static const proMonthly = 'astro_pro_monthly';
  static const premiumMonthly = 'astro_premium_monthly';
}
```

---

## Notes

### Testing Purchases
- Use sandbox accounts for testing
- Test all success and failure scenarios
- Test restore on fresh install
- Test upgrade/downgrade flows
- Verify receipt validation

### Privacy Compliance
- GDPR consent for ads (EU users)
- ATT prompt for iOS 14.5+
- Clear subscription terms
- Easy cancellation info

### Store Guidelines
- Clear subscription pricing
- Restore purchases button required
- Terms and Privacy links required
- No fake "free trial" tactics
