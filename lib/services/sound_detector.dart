import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundDetector {
  // Mutable so TimerNotifier can update it live while the detector is running.
  double threshold = 0.04;
  static const Duration _debounce = Duration(milliseconds: 1500);

  static const _channel = EventChannel('hands_free_timer/audio_stream');

  Process? _process;
  StreamSubscription<dynamic>? _subscription;
  DateTime? _lastTrigger;

  Future<void> start(void Function() onDetected) async {
    if (!kIsWeb && Platform.isLinux) {
      await _startLinux(onDetected);
    } else {
      _startMobile(onDetected);
    }
  }

  // Linux/WSLg: parec bridges to the Windows microphone via PulseAudio.
  Future<void> _startLinux(void Function() onDetected) async {
    _process = await Process.start('parec', [
      '--format=s16le',
      '--rate=16000',
      '--channels=1',
    ]);
    _subscription = _process!.stdout
        .listen((chunk) => _handleChunk(chunk, onDetected));
  }

  // Android: native AudioRecord streamed via EventChannel.
  void _startMobile(void Function() onDetected) {
    _subscription = _channel.receiveBroadcastStream().listen(
      (dynamic data) {
        if (data is Uint8List) _handleChunk(data, onDetected);
      },
    );
  }

  void _handleChunk(List<int> chunk, void Function() onDetected) {
    if (_computeRms(chunk) > threshold) {
      final now = DateTime.now();
      if (_lastTrigger == null || now.difference(_lastTrigger!) > _debounce) {
        _lastTrigger = now;
        onDetected();
      }
    }
  }

  double _computeRms(List<int> chunk) {
    if (chunk.length < 2) return 0;
    final bytes = Uint8List.fromList(chunk);
    final samples = bytes.buffer.asInt16List();
    double sum = 0;
    for (final s in samples) {
      sum += s * s;
    }
    return sqrt(sum / samples.length) / 32768.0;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _lastTrigger = null;
    _process?.kill();
    _process = null;
  }

  Future<void> dispose() async => stop();
}
