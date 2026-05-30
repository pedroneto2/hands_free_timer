// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Temporizador por Voz';

  @override
  String get statusDone => 'Feito!';

  @override
  String get statusRunning => 'A correr';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get btnClapToRestart => 'Som para reiniciar';

  @override
  String get btnRestart => 'Reiniciar';

  @override
  String get btnClapToPause => 'Som para pausar';

  @override
  String get btnListeningClapToStart => 'Ouvindo: som para iniciar';

  @override
  String get btnPause => 'Pausar';

  @override
  String get btnStart => 'Iniciar';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get dialogCustomDuration => 'DURAÇÃO PERSONALIZADA';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogSet => 'Definir';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'seg';

  @override
  String get micSensitivity => 'SENSIBILIDADE DO MICROFONE';

  @override
  String get sensitivityLow => 'Baixa';

  @override
  String get sensitivityHigh => 'Alta';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get soundTrigger => 'Gatilho de som';

  @override
  String get soundModeAny => 'Qualquer';

  @override
  String get soundModeWhistle => 'Assobio';

  @override
  String get soundModeYell => 'Grito';

  @override
  String get soundModeVoice => 'Comando de Voz (Ok Time)';

  @override
  String get voiceCalibrating => 'Iniciando reconhecimento de voz...';

  @override
  String get voiceBatteryHint => 'Consome mais bateria do que os outros modos';

  @override
  String get helpButton => 'Instruções';

  @override
  String get helpTitle => 'Como usar';

  @override
  String get helpTimerCircleTitle => 'Círculo do Temporizador';

  @override
  String get helpTimerCircleBody =>
      'Toque no círculo do temporizador para abrir o painel de presets e escolher uma duração.';

  @override
  String get helpPresetsTitle => 'Presets';

  @override
  String get helpPresetsBody =>
      'Escolha uma duração predefinida ou adicione uma personalizada. Toque em × para remover um preset.';

  @override
  String get helpControlsTitle => 'Controlos';

  @override
  String get helpControlsBody =>
      'Prima Iniciar para começar, Pausar para pausar e Reiniciar para recomeçar o temporizador.';

  @override
  String get helpSoundTriggerTitle => 'Gatilho de Som';

  @override
  String get helpSoundTriggerBody =>
      'Ative o microfone (ícone do microfone) para controlar o temporizador com sons. Qualquer/Assobio/Grito: um som detetado inicia ou pausa. Comando de Voz: diga \"Ok Time\" para iniciar/pausar e \"Ok Reset\" para reiniciar.';

  @override
  String get helpSensitivityTitle => 'Sensibilidade do Microfone';

  @override
  String get helpSensitivityBody =>
      'Ajuste a sensibilidade do microfone. Baixa ignora ruídos de fundo; Alta reage a sons mais suaves. Não disponível no modo Comando de Voz.';

  @override
  String get helpScreenTitle => 'Brilho do Ecrã';

  @override
  String get helpScreenBody =>
      'O ícone do sol/lua mantém o ecrã aceso enquanto o temporizador está ativo. Os gatilhos de som também restauram o brilho automaticamente.';

  @override
  String get helpLanguageTitle => 'Idioma e Tema';

  @override
  String get helpLanguageBody =>
      'Toque no ícone de idioma para mudar o idioma da aplicação. Toque no ícone de contraste para alternar entre o tema claro e escuro.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Timer Mãos Livres';

  @override
  String get statusDone => 'Feito!';

  @override
  String get statusRunning => 'Rodando';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get btnClapToRestart => 'Som para reiniciar';

  @override
  String get btnRestart => 'Reiniciar';

  @override
  String get btnClapToPause => 'Som para pausar';

  @override
  String get btnListeningClapToStart => 'Ouvindo: som para iniciar';

  @override
  String get btnPause => 'Pausar';

  @override
  String get btnStart => 'Iniciar';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get dialogCustomDuration => 'DURAÇÃO PERSONALIZADA';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogSet => 'Definir';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'seg';

  @override
  String get micSensitivity => 'SENSIBILIDADE DO MICROFONE';

  @override
  String get sensitivityLow => 'Baixa';

  @override
  String get sensitivityHigh => 'Alta';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get soundTrigger => 'Gatilho de som';

  @override
  String get soundModeAny => 'Qualquer';

  @override
  String get soundModeWhistle => 'Assobio';

  @override
  String get soundModeYell => 'Grito';

  @override
  String get soundModeVoice => 'Comando de Voz (Ok Time)';

  @override
  String get voiceCalibrating => 'Iniciando reconhecimento de voz...';

  @override
  String get voiceBatteryHint => 'Usa mais bateria que os outros modos';

  @override
  String get helpButton => 'Instruções';

  @override
  String get helpTitle => 'Como usar';

  @override
  String get helpTimerCircleTitle => 'Círculo do Timer';

  @override
  String get helpTimerCircleBody =>
      'Toque no círculo do timer para abrir o painel de presets e escolher uma duração.';

  @override
  String get helpPresetsTitle => 'Presets';

  @override
  String get helpPresetsBody =>
      'Escolha uma duração predefinida ou adicione uma personalizada. Toque em × para remover um preset.';

  @override
  String get helpControlsTitle => 'Controles';

  @override
  String get helpControlsBody =>
      'Pressione Iniciar para começar, Pausar para pausar e Reiniciar para resetar o timer.';

  @override
  String get helpSoundTriggerTitle => 'Gatilho de Som';

  @override
  String get helpSoundTriggerBody =>
      'Ative o microfone (ícone do microfone) para controlar o timer com sons. Qualquer/Assobio/Grito: um som detectado inicia ou pausa. Comando de Voz: diga \"Ok Time\" para iniciar/pausar e \"Ok Reset\" para reiniciar.';

  @override
  String get helpSensitivityTitle => 'Sensibilidade do Microfone';

  @override
  String get helpSensitivityBody =>
      'Ajuste a sensibilidade do microfone. Baixa ignora ruídos de fundo; Alta reage a sons mais suaves. Não disponível no modo Comando de Voz.';

  @override
  String get helpScreenTitle => 'Brilho da Tela';

  @override
  String get helpScreenBody =>
      'O ícone do sol/lua mantém a tela acesa enquanto o timer está ativo. Os gatilhos de som também restauram o brilho automaticamente.';

  @override
  String get helpLanguageTitle => 'Idioma e Tema';

  @override
  String get helpLanguageBody =>
      'Toque no ícone de idioma para mudar o idioma do app. Toque no ícone de contraste para alternar entre o tema claro e escuro.';
}
