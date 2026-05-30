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
  String get statusDone => '¡Terminado!';

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
  String get micSensitivity => 'SENSIBILIDAD DEL MICRÓFONO';

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

  @override
  String get soundModeVoice => 'Comando de Voz (Ok Time)';

  @override
  String get voiceCalibrating => 'Iniciando reconocimiento de voz...';

  @override
  String get voiceBatteryHint => 'Usa más batería que otros modos';

  @override
  String get helpButton => 'Instrucciones';

  @override
  String get helpTitle => 'Cómo usar';

  @override
  String get helpTimerCircleTitle => 'Círculo del Temporizador';

  @override
  String get helpTimerCircleBody =>
      'Toca el círculo del temporizador para abrir el panel de presets y elegir una duración.';

  @override
  String get helpPresetsTitle => 'Presets';

  @override
  String get helpPresetsBody =>
      'Elige una duración predefinida o añade una personalizada. Toca × para eliminar un preset.';

  @override
  String get helpControlsTitle => 'Controles';

  @override
  String get helpControlsBody =>
      'Pulsa Iniciar para comenzar, Pausar para pausar y Reiniciar para restablecer el temporizador.';

  @override
  String get helpSoundTriggerTitle => 'Activador de Sonido';

  @override
  String get helpSoundTriggerBody =>
      'Activa el micrófono (icono de micrófono) para controlar el temporizador con sonidos. Cualquiera/Silbido/Grito: un sonido detectado inicia o pausa. Comando de Voz: di \"Ok Time\" para iniciar/pausar y \"Ok Reset\" para reiniciar.';

  @override
  String get helpSensitivityTitle => 'Sensibilidad del Micrófono';

  @override
  String get helpSensitivityBody =>
      'Ajusta la sensibilidad del micrófono. Baja ignora el ruido de fondo; Alta reacciona a sonidos más suaves. No disponible en modo Comando de Voz.';

  @override
  String get helpScreenTitle => 'Brillo de Pantalla';

  @override
  String get helpScreenBody =>
      'El icono de sol/luna mantiene la pantalla encendida mientras el temporizador está activo. Los activadores de sonido también restauran el brillo automáticamente.';

  @override
  String get helpLanguageTitle => 'Idioma y Tema';

  @override
  String get helpLanguageBody =>
      'Toca el icono de idioma para cambiar el idioma de la app. Toca el icono de contraste para alternar entre el tema claro y oscuro.';
}
