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

  @override
  String get soundModeVoice => 'Perintah Suara (Ok Time)';

  @override
  String get voiceCalibrating => 'Memulai pengenalan suara...';

  @override
  String get voiceBatteryHint =>
      'Menggunakan lebih banyak baterai dari mode lain';

  @override
  String get helpButton => 'Panduan';

  @override
  String get helpTitle => 'Cara penggunaan';

  @override
  String get helpTimerCircleTitle => 'Lingkaran Timer';

  @override
  String get helpTimerCircleBody =>
      'Ketuk lingkaran timer untuk membuka panel preset dan memilih durasi.';

  @override
  String get helpPresetsTitle => 'Preset';

  @override
  String get helpPresetsBody =>
      'Pilih durasi yang telah ditentukan atau tambahkan yang kustom. Ketuk × untuk menghapus preset.';

  @override
  String get helpControlsTitle => 'Kontrol';

  @override
  String get helpControlsBody =>
      'Tekan Mulai untuk memulai, Jeda untuk menjeda, dan Mulai ulang untuk mengatur ulang timer.';

  @override
  String get helpSoundTriggerTitle => 'Pemicu Suara';

  @override
  String get helpSoundTriggerBody =>
      'Aktifkan mikrofon (ikon mic) agar suara dapat mengontrol timer. Apa saja/Siulan/Teriakan: suara yang terdeteksi memulai atau menjeda. Perintah Suara: ucapkan \"Ok Time\" untuk mulai/jeda dan \"Ok Reset\" untuk mengatur ulang.';

  @override
  String get helpSensitivityTitle => 'Sensitivitas Mikrofon';

  @override
  String get helpSensitivityBody =>
      'Sesuaikan sensitivitas mikrofon. Rendah mengabaikan kebisingan latar; Tinggi bereaksi terhadap suara lebih pelan. Tidak tersedia dalam mode Perintah Suara.';

  @override
  String get helpScreenTitle => 'Kecerahan Layar';

  @override
  String get helpScreenBody =>
      'Ikon matahari/bulan menjaga layar tetap menyala selama timer aktif. Pemicu suara juga memulihkan kecerahan secara otomatis.';

  @override
  String get helpLanguageTitle => 'Bahasa & Tema';

  @override
  String get helpLanguageBody =>
      'Ketuk ikon bahasa untuk mengganti bahasa aplikasi. Ketuk ikon kontras untuk beralih antara tema terang dan gelap.';
}
