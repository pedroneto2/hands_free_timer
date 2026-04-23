import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../notifiers/timer_notifier.dart';

class AppOpenAdManager with WidgetsBindingObserver {
  static const _adUnitId = 'ca-app-pub-4361775098637470/7334317300';

  final TimerNotifier _timerNotifier;

  AppOpenAd? _ad;
  bool _isShowingAd = false;

  AppOpenAdManager({required TimerNotifier timerNotifier})
      : _timerNotifier = timerNotifier {
    WidgetsBinding.instance.addObserver(this);
  }

  void initialize() {
    _loadAd();
    Future.delayed(const Duration(milliseconds: 800), _tryShowAd);
  }

  void _loadAd() {
    AppOpenAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (_) => _ad = null,
      ),
    );
  }

  bool _shouldShow() => !_isShowingAd && !_timerNotifier.isRunning;

  Future<void> _tryShowAd() async {
    if (_ad == null || !_shouldShow()) return;
    _isShowingAd = true;
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: _releaseAd,
      onAdFailedToShowFullScreenContent: (ad, _) => _releaseAd(ad),
    );
    _ad!.show();
  }

  void _releaseAd(AppOpenAd ad) {
    ad.dispose();
    _ad = null;
    _isShowingAd = false;
    _loadAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _tryShowAd();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ad?.dispose();
  }
}
