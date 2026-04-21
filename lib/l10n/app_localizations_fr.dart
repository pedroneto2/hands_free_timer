// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Minuteur Mains Libres';

  @override
  String get statusDone => 'Terminé !';

  @override
  String get statusRunning => 'En cours';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusPaused => 'En pause';

  @override
  String get btnClapToRestart => 'Son pour recommencer';

  @override
  String get btnRestart => 'Recommencer';

  @override
  String get btnClapToPause => 'Son pour pause';

  @override
  String get btnListeningClapToStart => 'À l\'écoute : son pour démarrer';

  @override
  String get btnPause => 'Pause';

  @override
  String get btnStart => 'Démarrer';

  @override
  String get presetCustom => 'Personnalisé';

  @override
  String get dialogCustomDuration => 'DURÉE PERSONNALISÉE';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogSet => 'Définir';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'sec';

  @override
  String get micSensitivity => 'SENSIBILITÉ DU MIC';

  @override
  String get sensitivityLow => 'Basse';

  @override
  String get sensitivityHigh => 'Haute';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get soundTrigger => 'Déclencheur sonore';

  @override
  String get soundModeAny => 'N\'importe';

  @override
  String get soundModeWhistle => 'Sifflet';

  @override
  String get soundModeYell => 'Cri';
}
