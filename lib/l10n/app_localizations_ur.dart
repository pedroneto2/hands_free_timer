// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'ہینڈز فری ٹائمر';

  @override
  String get statusDone => 'مکمل!';

  @override
  String get statusRunning => 'چل رہا ہے';

  @override
  String get statusReady => 'تیار';

  @override
  String get statusPaused => 'روکا ہوا';

  @override
  String get btnClapToRestart => 'دوبارہ شروع کرنے کے لیے آواز';

  @override
  String get btnRestart => 'دوبارہ شروع';

  @override
  String get btnClapToPause => 'روکنے کے لیے آواز';

  @override
  String get btnListeningClapToStart => 'سن رہا ہے: شروع کرنے کے لیے آواز';

  @override
  String get btnPause => 'روکیں';

  @override
  String get btnStart => 'شروع کریں';

  @override
  String get presetCustom => 'حسب ضرورت';

  @override
  String get dialogCustomDuration => 'حسب ضرورت مدت';

  @override
  String get dialogCancel => 'منسوخ';

  @override
  String get dialogSet => 'سیٹ کریں';

  @override
  String get unitMin => 'منٹ';

  @override
  String get unitSec => 'سیکنڈ';

  @override
  String get micSensitivity => 'مائیک حساسیت';

  @override
  String get sensitivityLow => 'کم';

  @override
  String get sensitivityHigh => 'زیادہ';

  @override
  String get selectLanguage => 'زبان منتخب کریں';
}
