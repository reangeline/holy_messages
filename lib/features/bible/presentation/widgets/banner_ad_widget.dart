import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/state/premium_provider.dart';
import '../../../../core/ads/ad_units.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  String get _adUnitId {
    // In release: use configured real IDs; if empty, suppress ads to avoid 'Test mode' label
    if (kReleaseMode) {
      final id = AdUnits.bannerId();
      return id;
    }
    // In debug/profile: use AdMob test ids
    if (Platform.isAndroid) {
      return AdUnits.bannerId();
    } else if (Platform.isIOS) {
      return AdUnits.bannerId();
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    final isPremium = ref.read(premiumProvider);
    if (!isPremium) {
      if (kReleaseMode && _adUnitId.isEmpty) {
        // No real id configured; do not load ads in release to avoid test-mode UI
        return;
      }
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: _adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() => _isLoaded = true),
          onAdFailedToLoad: (ad, err) { ad.dispose(); },
        ),
        request: const AdRequest(),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumProvider);
    
    // Se é premium, não mostra anúncio
    if (isPremium || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}