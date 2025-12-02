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
- Consumable IAP (one-time purchases) - Phase 2
- Promotional codes system
- Affiliate/referral system
- Ad mediation (single network)

### Additional Features Added (Gap Coverage)
- Google Sign-In (FR-002)
- Guest Mode with limited features (FR-004)
- Content Moderation in AI prompts (FR-116-119)

### Backend Integration (NEW)
- Appwrite Function: ai-chat-response (OpenAI GPT-4)
- Appwrite Function: subscription-webhook (RevenueCat)
- IAIService interface with AppwriteAIService
- Chat system real AI integration
- Remaining TODO fixes (IAP, like, share, reset URL)

### Prerequisites (from Week 1-5)
- [x] AdModal widget (Week 3)
- [x] Settings screen with "Remove Ads"
- [x] Chat free credit system
- [x] User authentication

---

## Session 1: AdMob Setup & AI Service Integration (4 hours)

### Objectives
1. Create IAIService interface and implementations
2. Deploy ai-chat-response Appwrite Function
3. Configure AdMob account and app IDs
4. Set up google_mobile_ads package
5. Create AdService singleton
6. Implement ad initialization
7. Configure test ad units

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| `IAIService` | Interface for AI responses | Backend |
| `AppwriteAIService` | Calls Appwrite Function | Backend |
| `MockAIService` | Template-based fallback | Backend |
| `ai-chat-response` | Appwrite Function deployment | Backend |
| AdMob configuration | App IDs, Ad unit IDs | Setup |
| `AdService` | Singleton ad manager | Backend |
| Initialization flow | Init on app start | Frontend |
| Test mode | Test ad units configured | Setup |
| Platform setup | iOS/Android config files | Setup |

### AI Service Integration (NEW - Priority)
| Task | Duration | Type |
|------|----------|------|
| Create IAIService interface | 15 min | Backend |
| Create AppwriteAIService (calls function) | 30 min | Backend |
| Create MockAIService (template fallback) | 15 min | Backend |
| Deploy ai-chat-response Appwrite Function | 50 min | Backend |

### Appwrite Function: ai-chat-response
```javascript
// Trigger: HTTP
// Runtime: Node.js 18
// Input: { userId, astrologerId, message, sessionId }
// Logic:
// 1. Fetch astrologer's aiPersonaPrompt from database
// 2. Fetch last 10 messages for context
// 3. Apply content moderation guidelines to system prompt (FR-116-119)
// 4. Call OpenAI GPT-4 API
// 5. Save messages to Appwrite
// 6. Return response
```

### Content Moderation Guidelines (FR-116-119)
```javascript
// Add to system prompt in ai-chat-response function:
const contentModerationRules = `
IMPORTANT CONTENT MODERATION RULES:
- NEVER provide medical advice or diagnose health conditions (FR-116)
- NEVER provide specific financial investment advice (FR-117)
- For harmful or distressing queries, respond with empathy and redirect to professional help (FR-118)
- If user reports feeling suicidal or in crisis, provide helpline numbers
- Keep responses spiritually uplifting and positive
- Avoid making definitive predictions about death, serious illness, or major negative events
`;

// Append to aiPersonaPrompt before sending to OpenAI
const systemPrompt = astrologer.aiPersonaPrompt + '\n\n' + contentModerationRules;
```

### IAIService Interface
```dart
abstract class IAIService {
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  });
}
```

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
| Create IAIService interface | 15 min | Backend |
| Create AppwriteAIService | 30 min | Backend |
| Create MockAIService | 15 min | Backend |
| Deploy ai-chat-response Appwrite Function | 50 min | Backend |
| AdMob account setup | 30 min | App + ad units |
| Package configuration | 20 min | pubspec + imports |
| Platform files | 30 min | Android + iOS config |
| AdService class | 40 min | Singleton service |
| Test mode setup | 20 min | Test ad IDs |

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
- [ ] IAIService interface created with Result pattern
- [ ] AppwriteAIService calls Appwrite Function
- [ ] MockAIService provides template fallback
- [ ] ai-chat-response Appwrite Function deployed and tested
- [ ] AdMob initializes without errors
- [ ] Test ads load successfully
- [ ] No ads shown to premium users

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

## Session 3: Rewarded Ads + Chat Backend Integration (4 hours)

### Objectives
1. Integrate ChatRepository in chat_controller
2. Wire AI service to chat
3. Implement rewarded ad loading
4. Create reward callback system
5. Integrate with chat free credits
6. Build reward confirmation UI
7. Handle reward validation

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| Chat backend integration | Wire ChatRepository + AI | Backend |
| Rewarded ad loading | Preload on demand | Frontend |
| Reward callbacks | Credit system integration | Frontend |
| AdModal integration | "Watch Ad" button flow | Frontend |
| Reward confirmation | Success toast/animation | Frontend |
| Retry on failure | Reload if ad fails | Frontend |

### Chat Backend Integration (NEW)
| Task | Duration | Type |
|------|----------|------|
| Integrate ChatRepository in chat_controller | 30 min | Backend |
| Wire AI service to chat | 25 min | Backend |

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
| Integrate ChatRepository in chat_controller | 30 min | Backend |
| Wire AI service to chat | 25 min | Backend |
| Rewarded ad loading | 40 min | Preload logic |
| Reward callback | 35 min | onReward handler |
| Chat credit integration | 40 min | Add credits on reward |
| Success animation | 30 min | Reward received UI |
| Ad preloading | 20 min | Load next ad |

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
- [ ] ChatRepository integrated in chat_controller
- [ ] AI service wired to chat (real responses)
- [ ] Rewarded ad plays fully
- [ ] Credits added only on completion
- [ ] Early close gives no reward
- [ ] Success feedback shows
- [ ] Next ad preloads automatically

---

## Session 4: RevenueCat Setup & IAP TODO Fix (4 hours)

### Objectives
1. Fix IAP TODO in chat_controller
2. Configure RevenueCat account
3. Set up purchases_flutter package
4. Create SubscriptionService
5. Define subscription tiers
6. Implement purchase flow

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| IAP TODO fix | Fix chat_controller:146 | Bug Fix |
| RevenueCat config | Project + API keys | Setup |
| `SubscriptionService` | Purchase management | Backend |
| Subscription tiers | Basic, Pro, Premium | Backend |
| Purchase flow | Buy subscription | Frontend |
| Restore purchases | Restore on new device | Frontend |

### Bug Fix (NEW)
| Task | Duration | Type |
|------|----------|------|
| Fix IAP TODO in chat_controller | 25 min | Bug Fix |

```dart
// chat_controller.dart:146
// TODO: Implement IAP
// Fix: Wire SubscriptionService.purchasePackage() when user taps "Go Premium"
```

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
| Fix IAP TODO in chat_controller | 25 min | Bug Fix |
| RevenueCat setup | 40 min | Account + products |
| Package configuration | 25 min | purchases_flutter |
| SubscriptionService | 55 min | Full service |
| Purchase flow | 40 min | Buy subscription |
| Restore purchases | 25 min | Restore flow |
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
- [ ] IAP TODO fixed in chat_controller
- [ ] RevenueCat SDK initializes
- [ ] Offerings fetch successfully
- [ ] Purchase completes on sandbox
- [ ] Subscription status updates
- [ ] Restore works on new device

---

## Session 5: Paywall Screen & Remaining TODOs (4 hours)

### Objectives
1. Fix like persist TODO in horoscope_detail_controller
2. Fix sharing TODO (use share_plus)
3. Build Paywall/Subscription screen
4. Create feature comparison table
5. Implement subscription cards
6. Add premium feature gating
7. Handle subscription state changes

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| Like persist fix | Fix horoscope_detail_controller:83 | Bug Fix |
| Sharing fix | Fix horoscope_detail_controller:89 | Bug Fix |
| `PaywallScreen` | Subscription selection | Frontend |
| `SubscriptionCard` | Tier display card | Frontend |
| `FeatureComparison` | Feature table | Frontend |
| Feature gating | Check before access | Frontend |
| `PremiumService` | Centralized gating | Backend |

### Bug Fixes (NEW)
| Task | Duration | Type |
|------|----------|------|
| Fix like persist TODO | 20 min | Bug Fix |
| Fix sharing TODO (use share_plus) | 25 min | Bug Fix |

```dart
// horoscope_detail_controller.dart:83
// TODO: Persist like state
// Fix: Use SharedPreferences to save liked horoscopes

// horoscope_detail_controller.dart:89
// TODO: Implement sharing
// Fix: Use share_plus package to share horoscope content
```

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
| Fix like persist TODO | 20 min | Bug Fix |
| Fix sharing TODO | 25 min | Bug Fix |
| PaywallScreen | 55 min | Full screen |
| SubscriptionCard | 40 min | Tier card widget |
| FeatureComparison | 35 min | Comparison table |
| PremiumService | 30 min | Feature gating |
| Gating integration | 35 min | Check in features |

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
- [ ] Like state persists between sessions
- [ ] Sharing works with share_plus
- [ ] Paywall shows all tiers
- [ ] Popular tier highlighted
- [ ] Features properly gated
- [ ] Ads hidden for subscribers

---

## Session 6: Testing, Auth Enhancements & Final Cleanup (4 hours)

### Objectives
1. Fix reset URL TODO in appwrite_auth_service
2. Implement Google Sign-In (FR-002)
3. Implement Guest Mode (FR-004)
4. Verify all MockAstrologer references removed
5. Deploy subscription-webhook Appwrite Function
6. Test all purchase flows (sandbox)
7. Implement subscription analytics
8. Handle edge cases
9. Final integration testing

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| Reset URL fix | Fix appwrite_auth_service:232 | Bug Fix |
| Google Sign-In | OAuth integration (FR-002) | Feature |
| Guest Mode | Limited feature access (FR-004) | Feature |
| MockAstrologer verification | Confirm all removed | Cleanup |
| `subscription-webhook` | Appwrite Function deployment | Backend |
| Sandbox testing | All purchase flows | Testing |
| Analytics events | Purchase tracking | Backend |
| Edge case handling | Failures, cancels | Testing |
| Widget tests | Premium components | Testing |

### Final Cleanup & Auth Enhancements (NEW)
| Task | Duration | Type |
|------|----------|------|
| Fix reset URL TODO in appwrite_auth_service | 10 min | Bug Fix |
| Implement Google Sign-In | 45 min | Feature |
| Implement Guest Mode | 35 min | Feature |
| Verify all MockAstrologer references removed | 15 min | Cleanup |
| Deploy subscription-webhook Appwrite Function | 30 min | Backend |

### Google Sign-In Implementation (FR-002)
```dart
// 1. Add google_sign_in package to pubspec.yaml
// dependencies:
//   google_sign_in: ^6.2.1

// 2. Configure Firebase/Google Cloud Console
// - Create OAuth 2.0 credentials
// - Add SHA-1 fingerprint for Android
// - Configure iOS URL scheme

// 3. In AppwriteAuthService
Future<Result<UserModel, AppError>> signInWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return Result.failure(AuthError(message: 'Google sign-in cancelled'));
    }

    final googleAuth = await googleUser.authentication;

    // Create Appwrite OAuth2 session
    await _account.createOAuth2Session(
      provider: 'google',
      success: 'https://your-app.com/auth/callback',
      failure: 'https://your-app.com/auth/failure',
    );

    // Fetch or create user document
    final user = await _getOrCreateUserDocument(googleUser);
    return Result.success(user);
  } catch (e) {
    return Result.failure(AuthError(message: e.toString()));
  }
}
```

### Guest Mode Implementation (FR-004)
```dart
// Guest mode allows limited app access without authentication
// Limitations:
// - Cannot save favorites
// - Cannot access chat history
// - Limited to 3 chat messages total (not per day)
// - Cannot make purchases
// - Prompted to register after limitations hit

class GuestService extends GetxService {
  static GuestService get to => Get.find();

  final isGuest = false.obs;
  final guestChatCount = 0.obs;
  static const maxGuestChats = 3;

  void enterGuestMode() {
    isGuest.value = true;
    guestChatCount.value = 0;
    // Navigate to home with limited access
    Get.offAllNamed(Routes.HOME);
  }

  bool canGuestChat() {
    if (!isGuest.value) return true;
    return guestChatCount.value < maxGuestChats;
  }

  void incrementGuestChat() {
    guestChatCount.value++;
    if (guestChatCount.value >= maxGuestChats) {
      _showRegisterPrompt();
    }
  }

  void _showRegisterPrompt() {
    Get.dialog(
      AlertDialog(
        title: Text('Create an Account'),
        content: Text('Sign up to continue chatting and unlock all features!'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Maybe Later')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.REGISTER);
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

// In LoginScreen - add "Continue as Guest" button
TextButton(
  onPressed: () => GuestService.to.enterGuestMode(),
  child: Text('Continue as Guest'),
)
```

```dart
// appwrite_auth_service.dart:232
// TODO: Configure reset URL
// Fix: Set proper reset URL for password reset emails
```

### Appwrite Function: subscription-webhook
```javascript
// Trigger: HTTP (RevenueCat webhook)
// Runtime: Node.js 18
// Purpose: Sync subscription status to Appwrite
// Events: INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION
```

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
| Fix reset URL TODO | 10 min | Bug Fix |
| Implement Google Sign-In | 45 min | Feature |
| Implement Guest Mode | 35 min | Feature |
| Verify all mocks removed | 10 min | Cleanup |
| Deploy subscription-webhook | 25 min | Backend |
| Sandbox testing | 40 min | All flows verified |
| Analytics setup | 30 min | Event tracking |
| Edge case handling | 25 min | Error states |
| Widget tests | 30 min | Component tests |

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
- [ ] Reset URL configured in appwrite_auth_service
- [ ] Google Sign-In works on both iOS and Android
- [ ] Guest Mode allows limited browsing without login
- [ ] Guest users see registration prompt after 3 chats
- [ ] Guest users cannot save favorites or access history
- [ ] No MockAstrologer references remaining
- [ ] subscription-webhook Appwrite Function deployed
- [ ] All purchase flows work in sandbox
- [ ] Analytics events fire correctly
- [ ] Edge cases handled gracefully
- [ ] Widget tests pass

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
