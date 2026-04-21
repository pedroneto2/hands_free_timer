// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get micSensitivity => 'SENSIBILIDADE DO MIC';

  @override
  String get sensitivityLow => 'Baixa';

  @override
  String get sensitivityHigh => 'Alta';

  @override
  String get selectLanguage => 'Selecionar Idioma';
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
  String get micSensitivity => 'SENSIBILIDADE DO MIC';

  @override
  String get sensitivityLow => 'Baixa';

  @override
  String get sensitivityHigh => 'Alta';

  @override
  String get selectLanguage => 'Selecionar Idioma';
}
