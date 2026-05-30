// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '免提计时器';

  @override
  String get statusDone => '完成！';

  @override
  String get statusRunning => '运行中';

  @override
  String get statusReady => '准备';

  @override
  String get statusPaused => '已暂停';

  @override
  String get btnClapToRestart => '出声重新开始';

  @override
  String get btnRestart => '重新开始';

  @override
  String get btnClapToPause => '出声暂停';

  @override
  String get btnListeningClapToStart => '监听中：出声开始';

  @override
  String get btnPause => '暂停';

  @override
  String get btnStart => '开始';

  @override
  String get presetCustom => '自定义';

  @override
  String get dialogCustomDuration => '自定义时长';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogSet => '确定';

  @override
  String get unitMin => '分';

  @override
  String get unitSec => '秒';

  @override
  String get micSensitivity => '麦克风灵敏度';

  @override
  String get sensitivityLow => '低';

  @override
  String get sensitivityHigh => '高';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get soundTrigger => '声音触发';

  @override
  String get soundModeAny => '任意声音';

  @override
  String get soundModeWhistle => '哨声';

  @override
  String get soundModeYell => '呼喊';

  @override
  String get soundModeVoice => '语音指令 (Ok Time)';

  @override
  String get voiceCalibrating => '正在启动语音识别...';

  @override
  String get voiceBatteryHint => '比其他模式更耗电';

  @override
  String get helpButton => '说明';

  @override
  String get helpTitle => '使用方法';

  @override
  String get helpTimerCircleTitle => '计时器圆圈';

  @override
  String get helpTimerCircleBody => '点击计时器圆圈可打开预设面板并选择时长。';

  @override
  String get helpPresetsTitle => '预设';

  @override
  String get helpPresetsBody => '选择预设时长或添加自定义时长。点击 × 删除预设。';

  @override
  String get helpControlsTitle => '控制';

  @override
  String get helpControlsBody => '按开始键开始计时，按暂停键暂停，按重新开始键重置计时器。';

  @override
  String get helpSoundTriggerTitle => '声音触发';

  @override
  String get helpSoundTriggerBody =>
      '启用麦克风（麦克风图标）以通过声音控制计时器。任意/哨声/呼喊：检测到声音后开始或暂停。语音指令：说\"Ok Time\"开始/暂停，说\"Ok Reset\"重置。';

  @override
  String get helpSensitivityTitle => '麦克风灵敏度';

  @override
  String get helpSensitivityBody =>
      '调整麦克风灵敏度。低灵敏度忽略背景噪音；高灵敏度对较小声音作出响应。语音指令模式下不可用。';

  @override
  String get helpScreenTitle => '屏幕亮度';

  @override
  String get helpScreenBody => '太阳/月亮图标可在计时器运行时保持屏幕常亮。声音触发时也会自动恢复屏幕亮度。';

  @override
  String get helpLanguageTitle => '语言和主题';

  @override
  String get helpLanguageBody => '点击语言图标更改应用语言。点击对比度图标在亮色和暗色主题之间切换。';
}
