// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hands Free Timer';

  @override
  String get statusDone => 'Done!';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusPaused => 'Paused';

  @override
  String get btnClapToRestart => 'Sound to restart';

  @override
  String get btnRestart => 'Restart';

  @override
  String get btnClapToPause => 'Sound to pause';

  @override
  String get btnListeningClapToStart => 'Listening: sound to start';

  @override
  String get btnPause => 'Pause';

  @override
  String get btnStart => 'Start';

  @override
  String get presetCustom => 'Custom';

  @override
  String get dialogCustomDuration => 'CUSTOM DURATION';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogSet => 'Set';

  @override
  String get unitMin => 'min';

  @override
  String get unitSec => 'sec';

  @override
  String get micSensitivity => 'MIC SENSITIVITY';

  @override
  String get sensitivityLow => 'Low';

  @override
  String get sensitivityHigh => 'High';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get soundTrigger => 'Sound trigger';

  @override
  String get soundModeAny => 'Any';

  @override
  String get soundModeWhistle => 'Whistle';

  @override
  String get soundModeYell => 'Yell';

  @override
  String get soundModeVoice => 'Voice Cmd (Ok Time)';

  @override
  String get voiceCalibrating => 'Starting voice recognition...';

  @override
  String get voiceBatteryHint => 'Uses more battery than other modes';

  @override
  String get helpButton => 'Instructions';

  @override
  String get helpTitle => 'How to use';

  @override
  String get helpTimerCircleTitle => 'Timer Circle';

  @override
  String get helpTimerCircleBody =>
      'Tap the timer circle to open the preset panel and choose a duration.';

  @override
  String get helpPresetsTitle => 'Presets';

  @override
  String get helpPresetsBody =>
      'Choose a preset duration or add a custom one. Tap × to remove a preset.';

  @override
  String get helpControlsTitle => 'Controls';

  @override
  String get helpControlsBody =>
      'Press Start to begin, Pause to pause, and Restart to reset the timer.';

  @override
  String get helpSoundTriggerTitle => 'Sound Trigger';

  @override
  String get helpSoundTriggerBody =>
      'Enable the mic (mic icon) to let sounds control the timer. Any/Whistle/Yell: a detected sound starts or pauses. Voice Cmd: say \"Ok Time\" to start/pause and \"Ok Reset\" to reset.';

  @override
  String get helpSensitivityTitle => 'Mic Sensitivity';

  @override
  String get helpSensitivityBody =>
      'Adjust how sensitive the mic is to sound. Low ignores background noise; High reacts to quieter sounds. Not available in Voice Cmd mode.';

  @override
  String get helpScreenTitle => 'Screen Brightness';

  @override
  String get helpScreenBody =>
      'The sun/moon icon keeps the screen on while the timer is active. Sound triggers also restore screen brightness automatically.';

  @override
  String get helpLanguageTitle => 'Language & Theme';

  @override
  String get helpLanguageBody =>
      'Tap the language icon to change the app language. Tap the contrast icon to toggle between light and dark theme.';
}
