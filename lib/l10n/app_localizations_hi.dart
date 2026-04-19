// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हैंड्स फ्री टाइमर';

  @override
  String get statusDone => 'हो गया!';

  @override
  String get statusRunning => 'चल रहा है';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusPaused => 'रुका हुआ';

  @override
  String get btnClapToRestart => 'पुनः शुरू करने के लिए ताली';

  @override
  String get btnRestart => 'पुनः शुरू';

  @override
  String get btnClapToPause => 'रोकने के लिए ताली';

  @override
  String get btnListeningClapToStart => 'सुन रहा है: शुरू करने के लिए ताली';

  @override
  String get btnPause => 'रोकें';

  @override
  String get btnStart => 'शुरू करें';

  @override
  String get presetCustom => 'कस्टम';

  @override
  String get dialogCustomDuration => 'कस्टम अवधि';

  @override
  String get dialogCancel => 'रद्द करें';

  @override
  String get dialogSet => 'सेट करें';

  @override
  String get unitMin => 'मिनट';

  @override
  String get unitSec => 'सेकंड';

  @override
  String get micSensitivity => 'माइक संवेदनशीलता';

  @override
  String get sensitivityLow => 'कम';

  @override
  String get sensitivityHigh => 'अधिक';

  @override
  String get selectLanguage => 'भाषा चुनें';
}
