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
  String get btnClapToPause => 'Son pour mettre en pause';

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
  String get micSensitivity => 'SENSIBILITÉ DU MICRO';

  @override
  String get sensitivityLow => 'Basse';

  @override
  String get sensitivityHigh => 'Haute';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get soundTrigger => 'Déclencheur sonore';

  @override
  String get soundModeAny => 'Tous';

  @override
  String get soundModeWhistle => 'Sifflement';

  @override
  String get soundModeYell => 'Cri';

  @override
  String get soundModeVoice => 'Commande Vocale (Ok Time)';

  @override
  String get voiceCalibrating => 'Démarrage de la reconnaissance vocale...';

  @override
  String get voiceBatteryHint =>
      'Consomme plus de batterie que les autres modes';

  @override
  String get helpButton => 'Instructions';

  @override
  String get helpTitle => 'Comment utiliser';

  @override
  String get helpTimerCircleTitle => 'Cercle du minuteur';

  @override
  String get helpTimerCircleBody =>
      'Appuyez sur le cercle du minuteur pour ouvrir le panneau des presets et choisir une durée.';

  @override
  String get helpPresetsTitle => 'Presets';

  @override
  String get helpPresetsBody =>
      'Choisissez une durée prédéfinie ou ajoutez-en une personnalisée. Appuyez sur × pour supprimer un preset.';

  @override
  String get helpControlsTitle => 'Contrôles';

  @override
  String get helpControlsBody =>
      'Appuyez sur Démarrer pour commencer, Pause pour suspendre et Recommencer pour réinitialiser le minuteur.';

  @override
  String get helpSoundTriggerTitle => 'Déclencheur sonore';

  @override
  String get helpSoundTriggerBody =>
      'Activez le micro (icône micro) pour contrôler le minuteur avec des sons. Tous/Sifflement/Cri : un son détecté démarre ou met en pause. Commande Vocale : dites \"Ok Time\" pour démarrer/pause et \"Ok Reset\" pour réinitialiser.';

  @override
  String get helpSensitivityTitle => 'Sensibilité du microphone';

  @override
  String get helpSensitivityBody =>
      'Ajustez la sensibilité du micro. Faible ignore les bruits de fond ; Haute réagit aux sons plus doux. Non disponible en mode Commande Vocale.';

  @override
  String get helpScreenTitle => 'Luminosité de l\'écran';

  @override
  String get helpScreenBody =>
      'L\'icône soleil/lune maintient l\'écran allumé pendant que le minuteur est actif. Les déclencheurs sonores restaurent également la luminosité automatiquement.';

  @override
  String get helpLanguageTitle => 'Langue et Thème';

  @override
  String get helpLanguageBody =>
      'Appuyez sur l\'icône de langue pour changer la langue de l\'application. Appuyez sur l\'icône de contraste pour basculer entre le thème clair et sombre.';
}
