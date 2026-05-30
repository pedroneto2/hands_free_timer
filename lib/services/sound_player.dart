import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundPlayer {
  static Uint8List? _cachedWav;
  static Uint8List? _cachedTriggerWav;
  static final _player = AudioPlayer();
  static final _triggerPlayer = AudioPlayer();

  static Future<void> playTriggerFeedback() async {
    try {
      final wav = _cachedTriggerWav ??= _buildWav(_generateTriggerBeep());
      if (!kIsWeb && Platform.isLinux) {
        final file = File('${Directory.systemTemp.path}/hft_trigger.wav');
        if (!file.existsSync()) await file.writeAsBytes(wav);
        Process.run('paplay', [file.path]).catchError((_) => ProcessResult(0, 0, null, null));
      } else {
        await _triggerPlayer.stop();
        await _triggerPlayer.play(BytesSource(wav));
      }
    } catch (_) {}
  }

  static Future<void> playCompletionAlert() async {
    try {
      final wav = _cachedWav ??= _buildWav(_generateChime());
      if (!kIsWeb && Platform.isLinux) {
        // Linux desktop: delegate to paplay (PulseAudio).
        final file = File('${Directory.systemTemp.path}/hft_alert.wav');
        if (!file.existsSync()) await file.writeAsBytes(wav);
        Future<void> run() async {
          try { await Process.run('paplay', [file.path]); } catch (_) {}
        }
        run();
      } else {
        // Android / iOS: play from memory via audioplayers.
        await _player.stop();
        await _player.play(BytesSource(wav));
      }
    } catch (_) {}
  }

  static Uint8List _generateTriggerBeep() {
    final a = _squareWave(1200, durationMs: 70);
    final gap = _silence(durationMs: 40);
    final c = _squareWave(1500, durationMs: 70);
    final out = Uint8List(a.length + gap.length + c.length);
    var off = 0;
    out.setRange(off, off += a.length, a);
    out.setRange(off, off += gap.length, gap);
    out.setRange(off, off += c.length, c);
    return out;
  }

  static Uint8List _generateChime() {
    // Each pitch is generated once and reused across the 8 alternating beats.
    final even = _squareWave(880, durationMs: 180);
    final odd  = _squareWave(1108, durationMs: 180);
    final sil  = _silence(durationMs: 80);
    final chunkLen = even.length + sil.length;
    final out = Uint8List(chunkLen * 8);
    var off = 0;
    for (var i = 0; i < 8; i++) {
      final wave = i.isEven ? even : odd;
      out.setRange(off, off += wave.length, wave);
      out.setRange(off, off += sil.length, sil);
    }
    return out;
  }

  static Uint8List _squareWave(int freq, {required int durationMs}) {
    const sampleRate = 44100;
    final n = sampleRate * durationMs ~/ 1000;
    final buf = ByteData(n * 2);
    for (var i = 0; i < n; i++) {
      final env = i < 256 ? i / 256.0 : (i > n - 256 ? (n - i) / 256.0 : 1.0);
      final raw = sin(2 * pi * freq * i / sampleRate) >= 0 ? 1.0 : -1.0;
      final s = (raw * 32767 * env).round().clamp(-32768, 32767);
      buf.setInt16(i * 2, s, Endian.little);
    }
    return buf.buffer.asUint8List();
  }

  static Uint8List _silence({required int durationMs}) =>
      Uint8List(44100 * durationMs ~/ 1000 * 2);

  static Uint8List _buildWav(Uint8List pcm) {
    final dataLen = pcm.length;
    final header = ByteData(44);
    void str(int offset, String s) {
      for (var i = 0; i < s.length; i++) {
        header.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    str(0, 'RIFF');
    header.setUint32(4, 36 + dataLen, Endian.little);
    str(8, 'WAVE');
    str(12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);  // PCM
    header.setUint16(22, 1, Endian.little);  // mono
    header.setUint32(24, 44100, Endian.little);
    header.setUint32(28, 44100 * 2, Endian.little);
    header.setUint16(32, 2, Endian.little);
    header.setUint16(34, 16, Endian.little);
    str(36, 'data');
    header.setUint32(40, dataLen, Endian.little);

    final out = Uint8List(44 + dataLen);
    out.setRange(0, 44, header.buffer.asUint8List());
    out.setRange(44, 44 + dataLen, pcm);
    return out;
  }
}
