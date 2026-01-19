import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/impl/ad_service.dart';
import '../../core/services/impl/subscription_service.dart';

class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  Timer? _retryTimer;
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final AdService _adService = Get.find<AdService>();
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // Don't load if premium
    if (_subscriptionService.isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: _adService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          if (mounted) {
             _retryTimer?.cancel();
             _retryTimer = Timer(const Duration(seconds: 30), () {
               if (mounted) _loadAd();
             });
          }
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide if premium upgrades happen while on screen
      if (_subscriptionService.isPremium) {
        return const SizedBox.shrink();
      }

      if (_bannerAd != null && _isAdLoaded) {
        return SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      }

      // Placeholder or empty while loading
      // For banners, we usually show nothing until loaded to avoid layout jumps,
      // or a placeholder if layout stability is preferred.
      // Given the design (bottom of screen), empty is usually fine or a fixed height container.
      // returning SizedBox.shrink() effectively hides it.
      return SizedBox(
        height: widget.adSize.height.toDouble(),
        width: widget.adSize.width.toDouble(),
      ); 
    });
  }
}
