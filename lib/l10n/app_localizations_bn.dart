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

  @override
  String get helpButton => 'নির্দেশিকা';

  @override
  String get helpTitle => 'কীভাবে ব্যবহার করবেন';

  @override
  String get helpTimerCircleTitle => 'টাইমার সার্কেল';

  @override
  String get helpTimerCircleBody =>
      'প্রিসেট প্যানেল খুলতে এবং সময়কাল বেছে নিতে টাইমার সার্কেলে ট্যাপ করুন।';

  @override
  String get helpPresetsTitle => 'প্রিসেট';

  @override
  String get helpPresetsBody =>
      'একটি পূর্বনির্ধারিত সময়কাল বেছে নিন বা কাস্টম একটি যোগ করুন। প্রিসেট মুছতে × ট্যাপ করুন।';

  @override
  String get helpControlsTitle => 'নিয়ন্ত্রণ';

  @override
  String get helpControlsBody =>
      'শুরু করতে Start চাপুন, থামাতে Pause চাপুন এবং পুনরায় সেট করতে Restart চাপুন।';

  @override
  String get helpSoundTriggerTitle => 'শব্দ ট্রিগার';

  @override
  String get helpSoundTriggerBody =>
      'মাইক্রোফোন (মাইক আইকন) সক্ষম করুন যাতে শব্দ দিয়ে টাইমার নিয়ন্ত্রণ করা যায়। যেকোনো/শিস/চিৎকার: শনাক্ত শব্দ শুরু বা বিরতি দেয়। ভয়েস কমান্ড: শুরু/বিরতির জন্য \"Ok Time\" এবং রিসেটের জন্য \"Ok Reset\" বলুন।';

  @override
  String get helpSensitivityTitle => 'মাইক সংবেদনশীলতা';

  @override
  String get helpSensitivityBody =>
      'মাইক্রোফোনের সংবেদনশীলতা সামঞ্জস্য করুন। কম হলে পটভূমির শব্দ উপেক্ষা করে; বেশি হলে শান্ত শব্দে প্রতিক্রিয়া দেখায়। ভয়েস কমান্ড মোডে পাওয়া যায় না।';

  @override
  String get helpScreenTitle => 'স্ক্রিন উজ্জ্বলতা';

  @override
  String get helpScreenBody =>
      'সূর্য/চাঁদ আইকন টাইমার সক্রিয় থাকাকালীন স্ক্রিন চালু রাখে। শব্দ ট্রিগারগুলি স্বয়ংক্রিয়ভাবে উজ্জ্বলতা পুনরুদ্ধার করে।';

  @override
  String get helpLanguageTitle => 'ভাষা ও থিম';

  @override
  String get helpLanguageBody =>
      'অ্যাপের ভাষা পরিবর্তন করতে ভাষা আইকনে ট্যাপ করুন। হালকা এবং গাঢ় থিমের মধ্যে টগল করতে কনট্রাস্ট আইকনে ট্যাপ করুন।';
}
