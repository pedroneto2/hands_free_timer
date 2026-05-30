// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مؤقت صوتي';

  @override
  String get statusDone => 'انتهى!';

  @override
  String get statusRunning => 'يعمل';

  @override
  String get statusReady => 'جاهز';

  @override
  String get statusPaused => 'متوقف مؤقتاً';

  @override
  String get btnClapToRestart => 'صوت لإعادة التشغيل';

  @override
  String get btnRestart => 'إعادة التشغيل';

  @override
  String get btnClapToPause => 'صوت للإيقاف المؤقت';

  @override
  String get btnListeningClapToStart => 'يستمع: صوت للتشغيل';

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
  String get soundTrigger => 'محفّز الصوت';

  @override
  String get soundModeAny => 'أي صوت';

  @override
  String get soundModeWhistle => 'صفير';

  @override
  String get soundModeYell => 'صراخ';

  @override
  String get soundModeVoice => 'أمر صوتي (Ok Time)';

  @override
  String get voiceCalibrating => 'جارٍ بدء التعرف على الصوت...';

  @override
  String get voiceBatteryHint => 'يستهلك بطارية أكثر من الأوضاع الأخرى';

  @override
  String get helpButton => 'تعليمات';

  @override
  String get helpTitle => 'كيفية الاستخدام';

  @override
  String get helpTimerCircleTitle => 'دائرة المؤقت';

  @override
  String get helpTimerCircleBody =>
      'انقر على دائرة المؤقت لفتح لوحة الإعدادات المسبقة واختيار مدة.';

  @override
  String get helpPresetsTitle => 'الإعدادات المسبقة';

  @override
  String get helpPresetsBody =>
      'اختر مدة محددة مسبقاً أو أضف مدة مخصصة. انقر × لحذف إعداد مسبق.';

  @override
  String get helpControlsTitle => 'أدوات التحكم';

  @override
  String get helpControlsBody =>
      'اضغط ابدأ للبدء، وإيقاف مؤقت للتوقف، وإعادة التشغيل لإعادة ضبط المؤقت.';

  @override
  String get helpSoundTriggerTitle => 'محفّز الصوت';

  @override
  String get helpSoundTriggerBody =>
      'فعّل الميكروفون (أيقونة الميكروفون) للتحكم في المؤقت بالصوت. أي/صفير/صراخ: الصوت المكتشف يبدأ أو يوقف مؤقتاً. الأمر الصوتي: قل \"Ok Time\" للبدء/الإيقاف المؤقت و\"Ok Reset\" لإعادة الضبط.';

  @override
  String get helpSensitivityTitle => 'حساسية الميكروفون';

  @override
  String get helpSensitivityBody =>
      'اضبط حساسية الميكروفون. منخفضة تتجاهل الضوضاء الخلفية؛ عالية تستجيب للأصوات الهادئة. غير متاح في وضع الأمر الصوتي.';

  @override
  String get helpScreenTitle => 'سطوع الشاشة';

  @override
  String get helpScreenBody =>
      'أيقونة الشمس/القمر تبقي الشاشة مضاءة أثناء تشغيل المؤقت. محفّزات الصوت تستعيد السطوع تلقائياً.';

  @override
  String get helpLanguageTitle => 'اللغة والسمة';

  @override
  String get helpLanguageBody =>
      'انقر على أيقونة اللغة لتغيير لغة التطبيق. انقر على أيقونة التباين للتبديل بين السمة الفاتحة والداكنة.';
}
