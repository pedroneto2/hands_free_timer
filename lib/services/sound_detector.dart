import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class SoundDetector {
  // Mutable so TimerNotifier can update it live while the detector is running.
  double threshold = 0.04;
  static const Duration _debounce = Duration(milliseconds: 1500);

  Process? _process;
  StreamSubscription<List<int>>? _subscription;
  DateTime? _lastTrigger;

  Future<void> start(void Function() onDetected) async {
    // parec is part of pulseaudio-utils (sudo apt install pulseaudio-utils)
    // On WSL2+WSLg the PULSE_SERVER env var points to the WSLg PulseAudio
    // server which bridges to the Windows microphone automatically.
    _process = await Process.start('parec', [
      '--format=s16le',
      '--rate=16000',
      '--channels=1',
    ]);

    _subscription = _process!.stdout.listen((chunk) {
      if (_computeRms(chunk) > threshold) {
        final now = DateTime.now();
        if (_lastTrigger == null || now.difference(_lastTrigger!) > _debounce) {
          _lastTrigger = now;
          onDetected();
        }
      }
    });
  }

  double _computeRms(List<int> chunk) {
    if (chunk.length < 2) return 0;
    final samples = Uint8List.fromList(chunk).buffer.asInt16List();
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