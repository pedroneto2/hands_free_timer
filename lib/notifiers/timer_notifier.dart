import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show HapticFeedback, MethodChannel;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/foreground_timer_service.dart';
import '../services/notification_service.dart';
import '../services/sound_detector.dart';
import '../services/sound_player.dart';
import '../services/voice_command_detector.dart';

enum TimerStatus { ready, running, paused, completed }

class TimerNotifier extends ChangeNotifier {
  static const List<int> presets = [1, 5, 10, 15, 30];
  static final Set<int> _kBuiltInSeconds = presets.map((m) => m * 60).toSet();

  static const _kEndTimeMs = 'timer_end_ms';
  static const _kTotalSec = 'timer_total_sec';
  static const _kRemainingSec = 'timer_remaining_sec';
  static const _kWasPaused = 'timer_was_paused';
  static const _kPreset = 'timer_preset_min';
  static const _kCustomSec = 'timer_custom_sec';
  static const _kCustomPresets = 'custom_presets_list';
  static const _kHiddenBuiltIns = 'hidden_builtin_presets';

  int _selectedPreset = 10;
  int _totalSeconds = 10 * 60;
  int _remainingSeconds = 10 * 60;
  int? _customSeconds;
  List<int> _customPresets = [];
  Set<int> _hiddenBuiltIns = {};
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _soundActivated = false;
  double _sensitivity = 0.8;
  SoundMode _soundMode = SoundMode.any;

  bool _isCalibrating = false;
  String? _voiceInitError;

  final SoundDetector _detector = SoundDetector();
  final VoiceCommandDetector _voiceDetector = VoiceCommandDetector();

  int get selectedPreset => _selectedPreset;
  int? get customSeconds => _customSeconds;
  List<int> get customPresets => List.unmodifiable(_customPresets);
  Set<int> get hiddenBuiltInPresets => Set.unmodifiable(_hiddenBuiltIns);
  bool get isRunning => _isRunning;
  bool get isCompleted => _isCompleted;
  bool get soundActivated => _soundActivated;
  double get sensitivity => _sensitivity;
  SoundMode get soundMode => _soundMode;
  bool get isCalibrating => _isCalibrating;
  String? get voiceInitError => _voiceInitError;

  void clearVoiceInitError() {
    _voiceInitError = null;
  }

  void setSoundMode(SoundMode mode) {
    if (_soundMode == mode) return;
    _soundMode = mode;
    if (mode != SoundMode.voice) {
      _detector.soundMode = mode;
    }
    if (_soundActivated) {
      _restartActiveDetector();
    }
    notifyListeners();
  }

  double get _rmsThreshold => 0.20 - 0.19 * _sensitivity;

  void setSensitivity(double value) {
    _sensitivity = value.clamp(0.0, 1.0);
    _detector.threshold = _rmsThreshold;
    notifyListeners();
  }

  double get progress =>
      _totalSeconds == 0 ? 0 : 1.0 - (_remainingSeconds / _totalSeconds);

  String get timeDisplay {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  TimerStatus get status {
    if (_isCompleted) return TimerStatus.completed;
    if (_isRunning) return TimerStatus.running;
    return _remainingSeconds == _totalSeconds
        ? TimerStatus.ready
        : TimerStatus.paused;
  }

  void selectPreset(int minutes) {
    if (_isRunning) return;
    _customSeconds = null;
    _selectedPreset = minutes;
    _totalSeconds = minutes * 60;
    _remainingSeconds = minutes * 60;
    _isCompleted = false;
    notifyListeners();
  }

  void selectBySeconds(int seconds) {
    if (_isRunning) return;
    _customSeconds = seconds;
    _selectedPreset = -1;
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
    _isCompleted = false;
    notifyListeners();
  }

  void startPause() {
    if (_isCompleted) {
      reset();
      return;
    }
    _isRunning ? pause() : _start();
  }

  Future<void> addCustomPreset(int seconds) async {
    if (!_kBuiltInSeconds.contains(seconds) && !_customPresets.contains(seconds)) {
      _customPresets = [..._customPresets, seconds];
      await _saveCustomPresets();
    }
    if (_kBuiltInSeconds.contains(seconds)) {
      selectPreset(seconds ~/ 60);
    } else {
      selectBySeconds(seconds);
    }
  }

  Future<void> removeCustomPreset(int seconds) async {
    _customPresets = _customPresets.where((s) => s != seconds).toList();
    await _saveCustomPresets();
    notifyListeners();
  }

  Future<void> hideBuiltInPreset(int minutes) async {
    _hiddenBuiltIns = {..._hiddenBuiltIns, minutes};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kHiddenBuiltIns,
      _hiddenBuiltIns.map((m) => m.toString()).toList(),
    );
    notifyListeners();
  }

  Future<void> _saveCustomPresets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kCustomPresets,
      _customPresets.map((s) => s.toString()).toList(),
    );
  }

  Future<void> initFromSaved() async {
    final prefs = await SharedPreferences.getInstance();

    final rawPresets = prefs.getStringList(_kCustomPresets);
    if (rawPresets != null) {
      _customPresets = rawPresets.map(int.parse).toList();
    }

    final rawHidden = prefs.getStringList(_kHiddenBuiltIns);
    if (rawHidden != null) {
      _hiddenBuiltIns = rawHidden.map(int.parse).toSet();
    }

    final total = prefs.getInt(_kTotalSec);
    if (total == null) return;

    _totalSeconds = total;
    _selectedPreset = prefs.getInt(_kPreset) ?? _selectedPreset;
    _customSeconds = prefs.getInt(_kCustomSec);

    final endTimeMs = prefs.getInt(_kEndTimeMs);
    if (endTimeMs != null) {
      final remainingMs = endTimeMs - DateTime.now().millisecondsSinceEpoch;
      if (remainingMs > 0) {
        _remainingSeconds = (remainingMs / 1000).ceil();
        _start();
      } else {
        _remainingSeconds = 0;
        _onComplete();
      }
      return;
    }

    final wasPaused = prefs.getBool(_kWasPaused) ?? false;
    final remaining = prefs.getInt(_kRemainingSec);
    if (wasPaused && remaining != null) {
      _remainingSeconds = remaining;
    }
  }

  void _saveRunningState() async {
    final prefs = await SharedPreferences.getInstance();
    final endMs =
        DateTime.now().millisecondsSinceEpoch + _remainingSeconds * 1000;
    await prefs.setInt(_kEndTimeMs, endMs);
    await prefs.setInt(_kTotalSec, _totalSeconds);
    await prefs.remove(_kRemainingSec);
    await prefs.remove(_kWasPaused);
    await prefs.setInt(_kPreset, _selectedPreset);
    final cs = _customSeconds;
    if (cs != null) {
      await prefs.setInt(_kCustomSec, cs);
    } else {
      await prefs.remove(_kCustomSec);
    }
  }

  void _savePausedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEndTimeMs);
    await prefs.setInt(_kRemainingSec, _remainingSeconds);
    await prefs.setInt(_kTotalSec, _totalSeconds);
    await prefs.setBool(_kWasPaused, true);
  }

  void _clearSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEndTimeMs);
    await prefs.remove(_kRemainingSec);
    await prefs.remove(_kTotalSec);
    await prefs.remove(_kWasPaused);
    await prefs.remove(_kPreset);
    await prefs.remove(_kCustomSec);
  }

  void _start() {
    _detector.suppress(const Duration(milliseconds: 2000));
    _voiceDetector.suppress(const Duration(milliseconds: 2000));
    _isRunning = true;
    notifyListeners();
    _saveRunningState();
    ForegroundTimerService.start(timeDisplay);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _onComplete();
        return;
      }
      _remainingSeconds--;
      final display = timeDisplay;
      notifyListeners();
      ForegroundTimerService.update(display);
    });
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
    _savePausedState();
    ForegroundTimerService.stop();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isCompleted = false;
    _remainingSeconds = _totalSeconds;
    notifyListeners();
    _clearSavedState();
    ForegroundTimerService.stop();
  }

  void _onComplete() {
    _timer?.cancel();
    // Suppress mic for 4 s so the completion chime doesn't re-trigger the detector.
    _detector.suppress(const Duration(seconds: 4));
    _voiceDetector.suppress(const Duration(seconds: 4));
    SoundPlayer.playCompletionAlert();
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 300), HapticFeedback.heavyImpact);
    Future.delayed(const Duration(milliseconds: 600), HapticFeedback.heavyImpact);
    _isRunning = false;
    _isCompleted = true;
    _remainingSeconds = 0;
    notifyListeners();
    _clearSavedState();
    ForegroundTimerService.stop();
    NotificationService.showTimerComplete(_totalSeconds);
  }

  static const _screenChannel = MethodChannel('hands_free_timer/screen');

  void _wakeScreen() {
    _screenChannel.invokeMethod('wakeScreen').catchError((_) {});
  }

  void _onSoundDetected() {
    _detector.suppress(const Duration(milliseconds: 3000));
    _voiceDetector.suppress(const Duration(milliseconds: 3000));
    SoundPlayer.playTriggerFeedback();
    _wakeScreen();
    startPause();
  }

  void _onVoiceReset() {
    _detector.suppress(const Duration(milliseconds: 3000));
    _voiceDetector.suppress(const Duration(milliseconds: 3000));
    SoundPlayer.playTriggerFeedback();
    _wakeScreen();
    reset();
  }

  Future<void> toggleSoundActivation() async {
    if (_soundActivated) {
      await _detector.stop();
      await _voiceDetector.stop();
      _soundActivated = false;
      _isCalibrating = false;
    } else {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          notifyListeners();
          return;
        }
      }
      _soundActivated = true;
      if (_soundMode == SoundMode.voice) {
        await _startVoiceDetector();
      } else {
        _detector.threshold = _rmsThreshold;
        _detector.soundMode = _soundMode;
        await _detector.start(_onSoundDetected);
      }
    }
    notifyListeners();
  }

  Future<void> _startVoiceDetector() async {
    _isCalibrating = true;
    notifyListeners();
    await _voiceDetector.start(
      onDetected: _onSoundDetected,
      onReset: _onVoiceReset,
      onCalibrationDone: () {
        _isCalibrating = false;
        notifyListeners();
      },
      onError: (msg) {
        _voiceInitError = msg;
        _soundActivated = false;
        _isCalibrating = false;
        notifyListeners();
      },
    );
  }

  Future<void> _restartActiveDetector() async {
    await _detector.stop();
    await _voiceDetector.stop();
    _isCalibrating = false;
    if (_soundMode == SoundMode.voice) {
      await _startVoiceDetector();
    } else {
      _detector.threshold = _rmsThreshold;
      _detector.soundMode = _soundMode;
      await _detector.start(_onSoundDetected);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _detector.dispose();
    _voiceDetector.dispose();
    super.dispose();
  }
}
