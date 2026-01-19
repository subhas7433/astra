import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'subscription_service.dart';

class AdService extends GetxService with WidgetsBindingObserver {
  static AdService get to => Get.find();

  // Test Ad Unit IDs
  final String _androidBannerIdTest = 'ca-app-pub-3940256099942544/6300978111';
  final String _iosBannerIdTest = 'ca-app-pub-3940256099942544/2934735716';
  
  final String _androidAppOpenIdTest = 'ca-app-pub-3940256099942544/3419835294';
  final String _iosAppOpenIdTest = 'ca-app-pub-3940256099942544/5662855259';
  
  final String _androidRewardedIdTest = 'ca-app-pub-3940256099942544/5224354917';
  final String _iosRewardedIdTest = 'ca-app-pub-3940256099942544/1712485313';

  // Production Ad Unit IDs
  // Note: iOS IDs are placeholders as user only provided generic/Android-looking IDs
  // Assuming the provided IDs are for Android or shared if cross-platform config allows (unlikely, usually distinct).
  // User provided:
  // App open - ca-app-pub-2063094445044192/3844172313
  // Reward - ca-app-pub-2063094445044192/6676373300
  // Banner - ca-app-pub-2063094445044192/6470335653
  
  final String _androidBannerIdProd = 'ca-app-pub-2063094445044192/6470335653';
  final String _iosBannerIdProd = 'ca-app-pub-2063094445044192/6470335653'; // Use same for now or update if different
  
  final String _androidAppOpenIdProd = 'ca-app-pub-2063094445044192/3844172313';
  final String _iosAppOpenIdProd = 'ca-app-pub-2063094445044192/3844172313';
  
  final String _androidRewardedIdProd = 'ca-app-pub-2063094445044192/6676373300';
  final String _iosRewardedIdProd = 'ca-app-pub-2063094445044192/6676373300';

  String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _androidBannerIdTest : _iosBannerIdTest;
    }
    return Platform.isAndroid ? _androidBannerIdProd : _iosBannerIdProd;
  }

  String get appOpenAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _androidAppOpenIdTest : _iosAppOpenIdTest;
    }
    return Platform.isAndroid ? _androidAppOpenIdProd : _iosAppOpenIdProd;
  }

  String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _androidRewardedIdTest : _iosRewardedIdTest;
    }
    return Platform.isAndroid ? _androidRewardedIdProd : _iosRewardedIdProd;
  }

  // Ad Instances
  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;

  // State
  final isAppOpenAdAvailable = false.obs;
  final isRewardedReady = false.obs;
  bool _isShowingAd = false;
  
  // Free message count
  final freeMessageCount = 3.obs;
  
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    await MobileAds.instance.initialize();
    _loadAppOpenAd();
    _loadRewardedAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isAppOpenAdAvailable.value = true;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          isAppOpenAdAvailable.value = false;
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_subscriptionService.isPremium) {
      return;
    }
    
    if (_appOpenAd == null || !isAppOpenAdAvailable.value || _isShowingAd) {
      _loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        isAppOpenAdAvailable.value = false;
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        isAppOpenAdAvailable.value = false;
        _loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isRewardedReady.value = true;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isRewardedReady.value = false;
              _loadRewardedAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              isRewardedReady.value = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          isRewardedReady.value = false;
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (_subscriptionService.isPremium) {
      return true; // Premium users skip ads and get reward immediately
    }

    debugPrint('Attempting to show Rewarded Ad. Ready: ${isRewardedReady.value}');
    if (_rewardedAd != null && isRewardedReady.value) {
      final Completer<bool> completer = Completer<bool>();
      bool rewardEarned = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('Ad showed full screen content.');
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('Ad dismissed full screen content.');
          ad.dispose();
          isRewardedReady.value = false;
          _loadRewardedAd(); // Preload next
          if (!completer.isCompleted) {
            completer.complete(rewardEarned);
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('Ad failed to show full screen content: $error');
          ad.dispose();
          isRewardedReady.value = false;
          _loadRewardedAd();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('User earned reward: ${reward.amount} ${reward.type}');
          rewardEarned = true;
        },
      );
      
      return completer.future;
    } else {
      debugPrint('Rewarded Ad not ready. Reloading...');
      _loadRewardedAd();
      return false;
    }
  }

  void decrementCredit() {
    if (freeMessageCount.value > 0) {
      freeMessageCount.value--;
    }
  }

  void resetCredits() {
    freeMessageCount.value = 3;
  }
  
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    _rewardedAd?.dispose();
    super.onClose();
  }
}
