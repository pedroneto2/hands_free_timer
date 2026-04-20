import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/sound_detector.dart';
import '../services/sound_player.dart';

enum TimerStatus { ready, running, paused, completed }

class TimerNotifier extends ChangeNotifier {
  static const List<int> presets = [1, 5, 10, 15, 30];

  int _selectedPreset = 10;
  int _totalSeconds = 10 * 60;
  int _remainingSeconds = 10 * 60;
  int? _customSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _soundActivated = false;
  double _sensitivity = 0.8;

  final SoundDetector _detector = SoundDetector();

  int get selectedPreset => _selectedPreset;
  int? get customSeconds => _customSeconds;
  bool get isRunning => _isRunning;
  bool get isCompleted => _isCompleted;
  bool get soundActivated => _soundActivated;
  double get sensitivity => _sensitivity;

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

  void _start() {
    // No wakelock — we intentionally let the screen sleep to save battery.
    // The timer continues running in the background accurately.
    _isRunning = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _onComplete();
        return;
      }
      _remainingSeconds--;
      notifyListeners();
    });
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isCompleted = false;
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  void _onComplete() {
    _timer?.cancel();
    _wakeScreen();
    SoundPlayer.playCompletionAlert();
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 300), HapticFeedback.heavyImpact);
    Future.delayed(const Duration(milliseconds: 600), HapticFeedback.heavyImpact);
    _isRunning = false;
    _isCompleted = true;
    _remainingSeconds = 0;
    notifyListeners();
  }

  // Wakes the display via X11/XWayland DPMS commands (Linux/WSLg only).
  void _wakeScreen() {
    if (!Platform.isLinux) return;
    Future<void> run(List<String> args) async {
      try { await Process.run('xset', args); } catch (_) {}
    }
    run(['s', 'reset']);
    run(['dpms', 'force', 'on']);
  }

  Future<void> toggleSoundActivation() async {
    if (_soundActivated) {
      await _detector.stop();
      _soundActivated = false;
    } else {
      _soundActivated = true;
      _detector.threshold = _rmsThreshold;
      await _detector.start(startPause);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _detector.dispose();
    super.dispose();
  }
}
