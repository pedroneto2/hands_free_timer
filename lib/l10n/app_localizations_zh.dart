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
  String get btnClapToRestart => '拍手重新开始';

  @override
  String get btnRestart => '重新开始';

  @override
  String get btnClapToPause => '拍手暂停';

  @override
  String get btnListeningClapToStart => '聆听：拍手开始';

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
}
