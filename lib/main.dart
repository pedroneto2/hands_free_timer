import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';
import 'screens/timer_screen.dart';

// Global locale notifier — changed by the language selector in the app bar.
final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HandsFreeTimerApp());
}

class HandsFreeTimerApp extends StatelessWidget {
  const HandsFreeTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (_, locale, __) => MaterialApp(
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
