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
  String get btnClapToRestart => 'आवाज़ से पुनः शुरू';

  @override
  String get btnRestart => 'पुनः शुरू';

  @override
  String get btnClapToPause => 'आवाज़ से रोकें';

  @override
  String get btnListeningClapToStart => 'सुन रहा है: आवाज़ से शुरू';

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

  @override
  String get soundTrigger => 'ध्वनि ट्रिगर';

  @override
  String get soundModeAny => 'कोई भी';

  @override
  String get soundModeWhistle => 'सीटी';

  @override
  String get soundModeYell => 'चिल्लाहट';
}
