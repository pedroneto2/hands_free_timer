// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ভয়েস টাইমার';

  @override
  String get statusDone => 'সম্পন্ন!';

  @override
  String get statusRunning => 'চলছে';

  @override
  String get statusReady => 'প্রস্তুত';

  @override
  String get statusPaused => 'থামানো';

  @override
  String get btnClapToRestart => 'শব্দ দিয়ে পুনরায় শুরু';

  @override
  String get btnRestart => 'পুনরায় শুরু';

  @override
  String get btnClapToPause => 'শব্দ দিয়ে থামান';

  @override
  String get btnListeningClapToStart => 'শুনছি: শব্দ দিয়ে শুরু করুন';

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

  @override
  String get soundTrigger => 'শব্দ ট্রিগার';

  @override
  String get soundModeAny => 'যেকোনো';

  @override
  String get soundModeWhistle => 'শিস';

  @override
  String get soundModeYell => 'চিৎকার';

  @override
  String get soundModeVoice => 'ভয়েস কমান্ড (Ok Time)';

  @override
  String get voiceCalibrating => 'ভয়েস রিকগনিশন শুরু হচ্ছে...';

  @override
  String get voiceBatteryHint =>
      'অন্যান্য মোডের চেয়ে বেশি ব্যাটারি ব্যবহার করে';
}
