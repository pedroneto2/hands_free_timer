// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'वॉयस टाइमर';

  @override
  String get statusDone => 'हो गया!';

  @override
  String get statusRunning => 'चल रहा है';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusPaused => 'रुका हुआ';

  @override
  String get btnClapToRestart => 'आवाज़ से दोबारा शुरू';

  @override
  String get btnRestart => 'दोबारा शुरू';

  @override
  String get btnClapToPause => 'आवाज़ से रोकें';

  @override
  String get btnListeningClapToStart => 'सुन रहा है: आवाज़ से शुरू';

  @override
  String get btnPause => 'रोकें';

  @override
  String get btnStart => 'शुरू करें';

  @override
  String get presetCustom => 'कस्टम';

  @override
  String get dialogCustomDuration => 'कस्टम अवधि';

  @override
  String get dialogCancel => 'रद्द करें';

  @override
  String get dialogSet => 'सेट करें';

  @override
  String get unitMin => 'मिनट';

  @override
  String get unitSec => 'सेकंड';

  @override
  String get micSensitivity => 'माइक संवेदनशीलता';

  @override
  String get sensitivityLow => 'कम';

  @override
  String get sensitivityHigh => 'अधिक';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get soundTrigger => 'साउंड ट्रिगर';

  @override
  String get soundModeAny => 'कोई भी';

  @override
  String get soundModeWhistle => 'सीटी';

  @override
  String get soundModeYell => 'चिल्लाहट';

  @override
  String get soundModeVoice => 'वॉयस कमांड (Ok Time)';

  @override
  String get voiceCalibrating => 'वॉयस पहचान शुरू हो रही है...';

  @override
  String get voiceBatteryHint => 'अन्य मोड से अधिक बैटरी उपयोग करता है';

  @override
  String get helpButton => 'निर्देश';

  @override
  String get helpTitle => 'कैसे उपयोग करें';

  @override
  String get helpTimerCircleTitle => 'टाइमर सर्कल';

  @override
  String get helpTimerCircleBody =>
      'प्रीसेट पैनल खोलने और अवधि चुनने के लिए टाइमर सर्कल पर टैप करें।';

  @override
  String get helpPresetsTitle => 'प्रीसेट';

  @override
  String get helpPresetsBody =>
      'पूर्वनिर्धारित अवधि चुनें या कस्टम जोड़ें। प्रीसेट हटाने के लिए × टैप करें।';

  @override
  String get helpControlsTitle => 'नियंत्रण';

  @override
  String get helpControlsBody =>
      'शुरू करने के लिए Start, रोकने के लिए Pause और टाइमर रीसेट करने के लिए Restart दबाएं।';

  @override
  String get helpSoundTriggerTitle => 'साउंड ट्रिगर';

  @override
  String get helpSoundTriggerBody =>
      'माइक (माइक आइकन) चालू करें ताकि आवाज़ से टाइमर नियंत्रित हो। Any/Whistle/Yell: पकड़ी गई आवाज़ शुरू या रोकती है। Voice Cmd: शुरू/रोकने के लिए \"Ok Time\" और रीसेट के लिए \"Ok Reset\" कहें।';

  @override
  String get helpSensitivityTitle => 'माइक संवेदनशीलता';

  @override
  String get helpSensitivityBody =>
      'माइक की संवेदनशीलता समायोजित करें। कम पृष्ठभूमि शोर को अनदेखा करता है; अधिक शांत आवाज़ों पर प्रतिक्रिया देता है। Voice Cmd मोड में उपलब्ध नहीं।';

  @override
  String get helpScreenTitle => 'स्क्रीन चमक';

  @override
  String get helpScreenBody =>
      'सूर्य/चाँद आइकन टाइमर सक्रिय रहने के दौरान स्क्रीन चालू रखता है। साउंड ट्रिगर स्वचालित रूप से चमक बहाल करते हैं।';

  @override
  String get helpLanguageTitle => 'भाषा और थीम';

  @override
  String get helpLanguageBody =>
      'ऐप की भाषा बदलने के लिए भाषा आइकन टैप करें। हल्के और गहरे थीम के बीच टॉगल करने के लिए कंट्रास्ट आइकन टैप करें।';
}
