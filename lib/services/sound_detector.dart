import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum SoundMode { any, whistle, yell, voice }

class SoundDetector {
  // Mutable so TimerNotifier can update it live while the detector is running.
  double threshold = 0.04;
  SoundMode soundMode = SoundMode.any;
  static const Duration _debounce = Duration(milliseconds: 1500);

  // Reusable buffer for _zcrStats — avoids a heap allocation per audio chunk.
  final _zcrs = List<double>.filled(4, 0.0, growable: false);

  static const _channel = EventChannel('hands_free_timer/audio_stream');

  Process? _process;
  StreamSubscription<dynamic>? _subscription;
  DateTime? _lastTrigger;
  DateTime? _suppressedUntil;

  // Ignore all audio chunks until [duration] has elapsed.
  // Call this before playing any device sound to prevent self-triggering.
  void suppress(Duration duration) {
    final newUntil = DateTime.now().add(duration);
    final current = _suppressedUntil;
    if (current == null || newUntil.isAfter(current)) {
      _suppressedUntil = newUntil;
    }
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
    _process!.stderr.listen((_) {});
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
    final sup = _suppressedUntil;
    if (sup != null) {
      if (now.isBefore(sup)) return;
      _suppressedUntil = null;
    }
    // Avoid copy when the EventChannel already delivers a Uint8List (Android).
    final bytes = (chunk is Uint8List && chunk.offsetInBytes == 0)
        ? chunk
        : Uint8List.fromList(chunk);
    final samples = bytes.buffer.asInt16List();
    if (_aboveThreshold(samples) && _passesMode(samples)) {
      if (_lastTrigger == null || now.difference(_lastTrigger!) > _debounce) {
        _lastTrigger = now;
        onDetected();
      }
    }
  }

  bool _aboveThreshold(Int16List samples) {
    final limit = threshold * threshold * 32768.0 * 32768.0 * samples.length;
    double sum = 0;
    for (int i = 0; i < samples.length; i++) {
      final s = samples[i];
      sum += s * s;
      if (sum > limit) return true;
    }
    return false;
  }

  // Splits the chunk into 4 sub-frames and computes per-frame ZCR.
  // Returns avg, variance, and spread (max-min) across frames — O(N), no FFT.
  ({double avgZcr, double variance, double spread}) _zcrStats(Int16List samples) {
    const frames = 4;
    final frameSize = samples.length ~/ frames;
    for (int f = 0; f < frames; f++) {
      int crossings = 0;
      final start = f * frameSize;
      for (int i = start + 1; i < start + frameSize; i++) {
        if ((samples[i] >= 0) != (samples[i - 1] >= 0)) crossings++;
      }
      _zcrs[f] = crossings / frameSize;
    }
    final avg = (_zcrs[0] + _zcrs[1] + _zcrs[2] + _zcrs[3]) / frames;
    double varianceSum = 0.0;
    double lo = _zcrs[0], hi = _zcrs[0];
    for (int f = 0; f < frames; f++) {
      final d = _zcrs[f] - avg;
      varianceSum += d * d;
      if (_zcrs[f] < lo) lo = _zcrs[f];
      if (_zcrs[f] > hi) hi = _zcrs[f];
    }
    return (avgZcr: avg, variance: varianceSum / frames, spread: hi - lo);
  }

  bool _passesMode(Int16List samples) {
    if (soundMode == SoundMode.any) return true;
    // voice mode is handled by VoiceCommandDetector, not this detector
    if (soundMode == SoundMode.voice) return false;
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
      SoundMode.any || SoundMode.voice => true,
    };
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _lastTrigger = null;
    _suppressedUntil = null;
    _process?.kill();
    _process = null;
  }

  Future<void> dispose() async => stop();
}
