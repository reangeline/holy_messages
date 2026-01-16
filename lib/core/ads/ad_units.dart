import 'package:flutter/foundation.dart';

/// Configure your real AdMob unit IDs here before release.
/// When kReleaseMode is true and an ID is empty, the ad will be suppressed to avoid showing test ads to reviewers.
class AdUnits {
  // Production App & Unit IDs (provided by user)
  // App ID: ca-app-pub-4433667020677521~9961408979
  // Banner unit: ca-app-pub-4433667020677521/6114675069

  // Banner
  static const String iosBanner = 'ca-app-pub-4433667020677521/6114675069';
  static const String androidBanner = 'ca-app-pub-4433667020677521/6114675069';

  // Interstitial
  // Provided by user for full-screen ads (update/return pages)
  static const String iosInterstitial = 'ca-app-pub-4433667020677521/2166679437';
  static const String androidInterstitial = 'ca-app-pub-4433667020677521/2166679437';

  static String bannerId() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosBanner;
    } else {
      return androidBanner;
    }
  }

  static String interstitialId() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosInterstitial;
    } else {
      return androidInterstitial;
    }
  }
}
