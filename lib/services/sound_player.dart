import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class SoundPlayer {
  static Uint8List? _cachedWav;

  // Three ascending tones — C5 → E5 → G5 (major chord arpeggio).
  static Future<void> playCompletionAlert() async {
    try {
      final wav = _cachedWav ??= _buildWav(_generateChime());
      final file = File('${Directory.systemTemp.path}/hft_alert.wav');
      if (!file.existsSync()) await file.writeAsBytes(wav);
      Process.start('paplay', [file.path]); // fire-and-forget
    } catch (_) {}
  }

  static List<int> _generateChime() {
    final samples = <int>[];
    for (final freq in [523, 659, 784]) {
      samples.addAll(_sineWave(freq, durationMs: 160));
      samples.addAll(_silence(durationMs: 60));
    }
    return samples;
  }

  static List<int> _sineWave(int freq, {required int durationMs}) {
    const sampleRate = 44100;
    final n = sampleRate * durationMs ~/ 1000;
    final buf = ByteData(n * 2);
    for (var i = 0; i < n; i++) {
      // Short fade-in/out to avoid clicks.
      final env = i < 256 ? i / 256.0 : (i > n - 256 ? (n - i) / 256.0 : 1.0);
      final s = (sin(2 * pi * freq * i / sampleRate) * 26000 * env)
          .round()
          .clamp(-32768, 32767);
      buf.setInt16(i * 2, s, Endian.little);
    }
    return buf.buffer.asUint8List().toList();
  }

  static List<int> _silence({required int durationMs}) =>
      List.filled(44100 * durationMs ~/ 1000 * 2, 0);

  static Uint8List _buildWav(List<int> pcm) {
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
    out.setAll(0, header.buffer.asUint8List());
    out.setAll(44, pcm);
    return out;
  }
}
