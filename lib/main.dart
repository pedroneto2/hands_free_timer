import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifiers/timer_notifier.dart';
import 'screens/timer_screen.dart';
import 'services/app_open_ad_manager.dart';

final localeNotifier = ValueNotifier<Locale>(const Locale('en'));
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
final timerNotifier = TimerNotifier();
final navigatorKey = GlobalKey<NavigatorState>();
AppOpenAdManager? appOpenAdManager;

bool get isMobilePlatform =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

const _themeKey = 'theme_mode';

Future<void> _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString(_themeKey) == 'light') {
    themeModeNotifier.value = ThemeMode.light;
  }
}

Future<void> saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_themeKey, mode == ThemeMode.light ? 'light' : 'dark');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadTheme();
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
      builder: (context, locale, _) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) => MaterialApp(
          navigatorKey: navigatorKey,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: themeMode,
          home: const TimerScreen(),
        ),
      ),
    );
  }
}
