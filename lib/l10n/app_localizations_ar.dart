// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مؤقت اليدين الحرتين';

  @override
  String get statusDone => 'انتهى!';

  @override
  String get statusRunning => 'يعمل';

  @override
  String get statusReady => 'جاهز';

  @override
  String get statusPaused => 'متوقف مؤقتاً';

  @override
  String get btnClapToRestart => 'صوت لإعادة البدء';

  @override
  String get btnRestart => 'إعادة البدء';

  @override
  String get btnClapToPause => 'صوت للإيقاف المؤقت';

  @override
  String get btnListeningClapToStart => 'يستمع: صوت للبدء';

  @override
  String get btnPause => 'إيقاف مؤقت';

  @override
  String get btnStart => 'ابدأ';

  @override
  String get presetCustom => 'مخصص';

  @override
  String get dialogCustomDuration => 'مدة مخصصة';

  @override
  String get dialogCancel => 'إلغاء';

  @override
  String get dialogSet => 'تعيين';

  @override
  String get unitMin => 'دقيقة';

  @override
  String get unitSec => 'ثانية';

  @override
  String get micSensitivity => 'حساسية الميكروفون';

  @override
  String get sensitivityLow => 'منخفضة';

  @override
  String get sensitivityHigh => 'عالية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get soundTrigger => 'مشغّل الصوت';

  @override
  String get soundModeAny => 'أي صوت';

  @override
  String get soundModeWhistle => 'صفير';

  @override
  String get soundModeYell => 'صراخ';
}
