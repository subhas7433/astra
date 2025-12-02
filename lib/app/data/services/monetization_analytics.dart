import 'package:get/get.dart';
import '../../core/utils/app_logger.dart';

class MonetizationAnalytics {
  static const String _tag = 'MonetizationAnalytics';

  static void trackPaywallView(String source) {
    AppLogger.info('Analytics: Paywall viewed from $source', tag: _tag);
    // TODO: Integrate with Firebase Analytics or similar
  }

  static void trackSubscriptionStart(String tier, String price) {
    AppLogger.info('Analytics: Subscription started - Tier: $tier, Price: $price', tag: _tag);
  }

  static void trackSubscriptionCancel(String tier) {
    AppLogger.info('Analytics: Subscription cancelled - Tier: $tier', tag: _tag);
  }

  static void trackAdImpression(String adType) {
    AppLogger.info('Analytics: Ad impression - Type: $adType', tag: _tag);
  }

  static void trackAdClick(String adType) {
    AppLogger.info('Analytics: Ad click - Type: $adType', tag: _tag);
  }

  static void trackRewardedComplete() {
    AppLogger.info('Analytics: Rewarded ad completed', tag: _tag);
  }

  static void trackPurchaseError(String error) {
    AppLogger.error('Analytics: Purchase error - $error', tag: _tag);
  }
  
  static void trackRestoreSuccess() {
    AppLogger.info('Analytics: Purchases restored successfully', tag: _tag);
  }
}
