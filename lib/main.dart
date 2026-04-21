import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import 'notifiers/timer_notifier.dart';
import 'screens/timer_screen.dart';
import 'services/app_open_ad_manager.dart';

final localeNotifier = ValueNotifier<Locale>(const Locale('en'));
final timerNotifier = TimerNotifier();
final navigatorKey = GlobalKey<NavigatorState>();
AppOpenAdManager? appOpenAdManager;

bool get isMobilePlatform =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isMobilePlatform) {
    try {
      await MobileAds.instance.initialize();
      appOpenAdManager = AppOpenAdManager(
        timerNotifier: timerNotifier,
        navigatorKey: navigatorKey,
      );
      appOpenAdManager!.initialize();
    } catch (e) {
      debugPrint('AdMob init failed: $e');
    }
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HandsFreeTimerApp());
}

class HandsFreeTimerApp extends StatelessWidget {
  const HandsFreeTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, child) => MaterialApp(
        navigatorKey: navigatorKey,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const TimerScreen(),
      ),
    );
  }
}
