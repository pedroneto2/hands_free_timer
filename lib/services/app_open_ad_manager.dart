import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifiers/timer_notifier.dart';
import '../screens/ad_splash_screen.dart';

class AppOpenAdManager with WidgetsBindingObserver {
  static const _adUnitId = 'ca-app-pub-4361775098637470/7334317300';
  static const _capMs = 4 * 60 * 60 * 1000;
  static const _prefKey = 'last_app_open_ad_shown_ms';

  final TimerNotifier _timerNotifier;
  final GlobalKey<NavigatorState> _navigatorKey;

  AppOpenAd? _ad;
  bool _isShowingAd = false;
  bool _splashActive = false;

  final adLoadedNotifier = ValueNotifier<bool>(false);

  AppOpenAdManager({
    required TimerNotifier timerNotifier,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _timerNotifier = timerNotifier,
        _navigatorKey = navigatorKey {
    WidgetsBinding.instance.addObserver(this);
  }

  void initialize() {
    _loadAd();
    Future.delayed(const Duration(milliseconds: 800), _tryShowSplash);
  }

  void _loadAd() {
    adLoadedNotifier.value = false;
    AppOpenAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          adLoadedNotifier.value = true;
        },
        onAdFailedToLoad: (_) {
          _ad = null;
          adLoadedNotifier.value = false;
        },
      ),
    );
  }

  Future<bool> _shouldShow() async {
    if (_isShowingAd || _splashActive || _timerNotifier.isRunning) return false;
    final prefs = await SharedPreferences.getInstance();
    final lastMs = prefs.getInt(_prefKey) ?? 0;
    return DateTime.now().millisecondsSinceEpoch - lastMs >= _capMs;
  }

  Future<void> _tryShowSplash() async {
    if (!await _shouldShow()) return;
    final state = _navigatorKey.currentState;
    if (state == null) return;
    _splashActive = true;
    state.push(MaterialPageRoute<void>(
      builder: (_) => AdSplashScreen(
        adLoadedNotifier: adLoadedNotifier,
        showAd: _showAd,
        onClosed: _onSplashClosed,
      ),
    ));
  }

  Future<void> _showAd(BuildContext context, VoidCallback onDismissed) async {
    if (_ad == null || _isShowingAd) {
      onDismissed();
      return;
    }
    _isShowingAd = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, DateTime.now().millisecondsSinceEpoch);
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _releaseAd(ad);
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _releaseAd(ad);
        onDismissed();
      },
    );
    _ad!.show();
  }

  void _releaseAd(AppOpenAd ad) {
    ad.dispose();
    _ad = null;
    _isShowingAd = false;
    adLoadedNotifier.value = false;
    _loadAd();
  }

  void _onSplashClosed() => _splashActive = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _tryShowSplash();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    adLoadedNotifier.dispose();
    _ad?.dispose();
  }
}
