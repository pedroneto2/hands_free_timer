// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Temporizador Manos Libres';

  @override
  String get statusDone => '¡Listo!';

  @override
  String get statusRunning => 'En curso';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get btnClapToRestart => 'Sonido para reiniciar';

  @override
  String get btnRestart => 'Reiniciar';

  @override
  String get btnClapToPause => 'Sonido para pausar';

  @override
  String get btnListeningClapToStart => 'Escuchando: sonido para iniciar';

  @override
  String get btnPause => 'Pausar';

  @override
  String get btnStart => 'Iniciar';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get dialogCustomDuration => 'DURACIÓN PERSONALIZADA';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogSet => 'Establecer';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'seg';

  @override
  String get micSensitivity => 'SENSIBILIDAD DEL MIC';

  @override
  String get sensitivityLow => 'Baja';

  @override
  String get sensitivityHigh => 'Alta';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get soundTrigger => 'Activador de sonido';

  @override
  String get soundModeAny => 'Cualquiera';

  @override
  String get soundModeWhistle => 'Silbido';

  @override
  String get soundModeYell => 'Grito';
}
