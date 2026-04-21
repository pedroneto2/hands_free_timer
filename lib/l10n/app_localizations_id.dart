// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Timer Bebas Tangan';

  @override
  String get statusDone => 'Selesai!';

  @override
  String get statusRunning => 'Berjalan';

  @override
  String get statusReady => 'Siap';

  @override
  String get statusPaused => 'Dijeda';

  @override
  String get btnClapToRestart => 'Suara untuk mulai ulang';

  @override
  String get btnRestart => 'Mulai ulang';

  @override
  String get btnClapToPause => 'Suara untuk jeda';

  @override
  String get btnListeningClapToStart => 'Mendengarkan: suara untuk mulai';

  @override
  String get btnPause => 'Jeda';

  @override
  String get btnStart => 'Mulai';

  @override
  String get presetCustom => 'Kustom';

  @override
  String get dialogCustomDuration => 'DURASI KUSTOM';

  @override
  String get dialogCancel => 'Batal';

  @override
  String get dialogSet => 'Atur';

  @override
  String get unitMin => 'mnt';

  @override
  String get unitSec => 'dtk';

  @override
  String get micSensitivity => 'SENSITIVITAS MIC';

  @override
  String get sensitivityLow => 'Rendah';

  @override
  String get sensitivityHigh => 'Tinggi';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get soundTrigger => 'Pemicu suara';

  @override
  String get soundModeAny => 'Apa saja';

  @override
  String get soundModeWhistle => 'Siulan';

  @override
  String get soundModeYell => 'Teriakan';
}
