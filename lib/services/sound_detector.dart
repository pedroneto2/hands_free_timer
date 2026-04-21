import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum SoundMode { any, whistle, yell }

class SoundDetector {
  // Mutable so TimerNotifier can update it live while the detector is running.
  double threshold = 0.04;
  SoundMode soundMode = SoundMode.any;
  static const Duration _debounce = Duration(milliseconds: 1500);

  static const _channel = EventChannel('hands_free_timer/audio_stream');

  Process? _process;
  StreamSubscription<dynamic>? _subscription;
  DateTime? _lastTrigger;
  DateTime? _suppressedUntil;

  // Ignore all audio chunks until [duration] has elapsed.
  // Call this before playing any device sound to prevent self-triggering.
  void suppress(Duration duration) {
    _suppressedUntil = DateTime.now().add(duration);
  }

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
    if (chunk.length < 2) return;
    final now = DateTime.now();
    if (_suppressedUntil != null && now.isBefore(_suppressedUntil!)) return;
    final bytes = Uint8List.fromList(chunk);
    final samples = bytes.buffer.asInt16List();
    if (_computeRms(samples) > threshold && _passesMode(samples)) {
      if (_lastTrigger == null || now.difference(_lastTrigger!) > _debounce) {
        _lastTrigger = now;
        onDetected();
      }
    }
  }

  double _computeRms(Int16List samples) {
    double sum = 0;
    for (final s in samples) { sum += s * s; }
    return sqrt(sum / samples.length) / 32768.0;
  }

  // Splits the chunk into 4 sub-frames and computes per-frame ZCR.
  // Returns avg, variance, and spread (max-min) across frames — O(N), no FFT.
  ({double avgZcr, double variance, double spread}) _zcrStats(Int16List samples) {
    const frames = 4;
    final frameSize = samples.length ~/ frames;
    final zcrs = List<double>.filled(frames, 0);
    for (int f = 0; f < frames; f++) {
      int crossings = 0;
      final start = f * frameSize;
      for (int i = start + 1; i < start + frameSize; i++) {
        if ((samples[i] >= 0) != (samples[i - 1] >= 0)) crossings++;
      }
      zcrs[f] = crossings / frameSize;
    }
    final avg = (zcrs[0] + zcrs[1] + zcrs[2] + zcrs[3]) / frames;
    final variance = zcrs.fold(0.0, (s, z) => s + (z - avg) * (z - avg)) / frames;
    double lo = zcrs[0], hi = zcrs[0];
    for (final z in zcrs) {
      if (z < lo) lo = z;
      if (z > hi) hi = z;
    }
    return (avgZcr: avg, variance: variance, spread: hi - lo);
  }

  bool _passesMode(Int16List samples) {
    if (soundMode == SoundMode.any) return true;
    if (samples.length < 16) return false;
    final (:avgZcr, :variance, :spread) = _zcrStats(samples);
    return switch (soundMode) {
      // Pure tonal high-freq: all three gates must pass.
      //   avgZcr   – keeps the average pitch in the human-whistle band (~1760–3840 Hz at 16 kHz).
      //   variance – very low: the frequency barely drifts across the 4 sub-frames.
      //   spread   – max-minus-min ZCR stays tiny: no sub-frame breaks out of the band.
      // Together these reject speech, claps, noise, brief squeaks, and music.
      // 2900–3200 Hz band at 16 kHz → ZCR 0.3625–0.4000
      SoundMode.whistle => avgZcr  >= 0.18 &&
          avgZcr  <= 0.22 &&
          variance < 0.0008 &&
          spread   < 0.06,
      // Voiced mid-freq: ZCR in voice band + moderate variance (natural pitch variation).
      // Rejects: pure tones in voice range, random noise (too chaotic).
      SoundMode.yell => avgZcr >= 0.02 &&
          avgZcr <= 0.18 &&
          variance >= 0.0005 &&
          variance < 0.020,
      SoundMode.any => true,
    };
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
