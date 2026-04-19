// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hands Free Timer';

  @override
  String get statusDone => 'Done!';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusPaused => 'Paused';

  @override
  String get btnClapToRestart => 'Clap to restart';

  @override
  String get btnRestart => 'Restart';

  @override
  String get btnClapToPause => 'Clap to pause';

  @override
  String get btnListeningClapToStart => 'Listening: clap to start';

  @override
  String get btnPause => 'Pause';

  @override
  String get btnStart => 'Start';

  @override
  String get presetCustom => 'Custom';

  @override
  String get dialogCustomDuration => 'CUSTOM DURATION';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogSet => 'Set';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'sec';

  @override
  String get micSensitivity => 'MIC SENSITIVITY';

  @override
  String get sensitivityLow => 'Low';

  @override
  String get sensitivityHigh => 'High';

  @override
  String get selectLanguage => 'Select Language';
}
