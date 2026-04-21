// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'হ্যান্ডস ফ্রি টাইমার';

  @override
  String get statusDone => 'সম্পন্ন!';

  @override
  String get statusRunning => 'চলছে';

  @override
  String get statusReady => 'প্রস্তুত';

  @override
  String get statusPaused => 'বিরতি';

  @override
  String get btnClapToRestart => 'পুনরায় শুরু করতে শব্দ';

  @override
  String get btnRestart => 'পুনরায় শুরু';

  @override
  String get btnClapToPause => 'বিরতি দিতে শব্দ';

  @override
  String get btnListeningClapToStart => 'শুনছি: শুরু করতে শব্দ';

  @override
  String get btnPause => 'বিরতি দিন';

  @override
  String get btnStart => 'শুরু করুন';

  @override
  String get presetCustom => 'কাস্টম';

  @override
  String get dialogCustomDuration => 'কাস্টম সময়কাল';

  @override
  String get dialogCancel => 'বাতিল';

  @override
  String get dialogSet => 'সেট করুন';

  @override
  String get unitMin => 'মিনিট';

  @override
  String get unitSec => 'সেকেন্ড';

  @override
  String get micSensitivity => 'মাইক সংবেদনশীলতা';

  @override
  String get sensitivityLow => 'কম';

  @override
  String get sensitivityHigh => 'বেশি';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';
}
