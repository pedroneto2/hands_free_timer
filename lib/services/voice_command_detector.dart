import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

/// Detects the wake phrase "Ok Time" on-device using Vosk (offline, free).
///
/// On Android: uses vosk_flutter's SpeechService (native AudioRecord + VAD).
/// On Linux:   uses parec + manual acceptWaveformBytes with ambient gate.
///
/// Setup required (one-time):
///  1. Download vosk-model-small-en-us-0.15.zip (~40 MB) from:
///       https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
///  2. Place the zip at: assets/model/vosk-model-small-en-us-0.15.zip
///  3. The model is extracted automatically to the device on first run.
class VoiceCommandDetector {
  static const String _kModelAsset =
      'assets/model/vosk-model-small-en-us-0.15.zip';

  // Grammar limits Vosk to "ok time" only; [unk] absorbs non-matching speech.
  static const List<String> _kGrammar = ['ok time', '[unk]'];

  static const Duration _kDetectionDebounce = Duration(seconds: 2);

  // ── Linux-only constants ───────────────────────────────────────────────────
  static const double _kAmbientMultiplier = 2.0;
  static const Duration _kCalibrationDuration = Duration(seconds: 2);
  static const int _kMaxQueueSize = 30;
  static final Uint8List _kSilenceBuffer = Uint8List(3200); // 100 ms silence

  // ── Shared state ───────────────────────────────────────────────────────────
  Model? _model;
  Recognizer? _recognizer;
  bool _stopped = false;
  bool _isCalibrating = false;
  DateTime? _lastDetection;

  void Function()? _onDetected;
  void Function()? _onCalibrationDone;
  void Function(String)? _onError;

  // ── Android (SpeechService) state ──────────────────────────────────────────
  SpeechService? _speechService;
  StreamSubscription<String>? _resultSub;
  Timer? _suppressTimer;

  // ── Linux (manual waveform) state ──────────────────────────────────────────
  Process? _linuxProcess;
  StreamSubscription<dynamic>? _linuxSubscription;
  bool _isDrainingQueue = false;
  double _ambientBaseline = 0.0;
  DateTime? _calibrationEnd;
  double _calibrationSum = 0;
  int _calibrationCount = 0;
  DateTime? _suppressedUntil;
  bool _wasAboveGate = false;
  final _audioQueue = Queue<Uint8List>();

  bool get isCalibrating => _isCalibrating;

  // ── Public API ─────────────────────────────────────────────────────────────

  void suppress(Duration duration) {
    if (_speechService != null) {
      // SpeechService path: use native pause/resume
      _suppressTimer?.cancel();
      _speechService!.setPause(paused: true);
      _suppressTimer = Timer(duration, () {
        if (!_stopped) _speechService?.setPause(paused: false);
      });
    } else {
      // Linux path: timestamp gate
      _suppressedUntil = DateTime.now().add(duration);
    }
  }

  Future<void> start({
    required void Function() onDetected,
    required void Function() onCalibrationDone,
    required void Function(String) onError,
  }) async {
    _onDetected = onDetected;
    _onCalibrationDone = onCalibrationDone;
    _onError = onError;
    _stopped = false;
    _isCalibrating = true;

    try {
      final loader = ModelLoader();
      final modelPath = await loader.loadFromAssets(_kModelAsset);
      _model = await VoskFlutterPlugin.instance().createModel(modelPath);
      _recognizer = await VoskFlutterPlugin.instance().createRecognizer(
        model: _model!,
        sampleRate: 16000,
        grammar: _kGrammar,
      );
    } catch (e) {
      onError(
        'Falha ao carregar modelo Vosk.\n'
        'Baixe vosk-model-small-en-us-0.15.zip e coloque em assets/model/\n'
        '($e)',
      );
      _isCalibrating = false;
      return;
    }

    if (!kIsWeb && Platform.isLinux) {
      _calibrationEnd = DateTime.now().add(_kCalibrationDuration);
      _calibrationSum = 0;
      _calibrationCount = 0;
      await _startLinux();
      // calibration completes inside _handleChunk
    } else {
      // Android: SpeechService manages its own AudioRecord + VAD internally.
      // No manual calibration needed — just show the modal during init.
      try {
        _speechService =
            await VoskFlutterPlugin.instance().initSpeechService(_recognizer!);
        _resultSub =
            _speechService!.onResult().listen(_handleSpeechServiceResult);
        await _speechService!.start();
      } catch (e) {
        onError('Falha ao iniciar serviço de voz: $e');
        _isCalibrating = false;
        return;
      }
      _isCalibrating = false;
      _onCalibrationDone?.call();
    }
  }

  Future<void> stop() async {
    _stopped = true;
    _suppressTimer?.cancel();
    _suppressTimer = null;

    // Android cleanup
    await _resultSub?.cancel();
    _resultSub = null;
    if (_speechService != null) {
      await _speechService!.stop();
      await _speechService!.dispose();
      _speechService = null;
    }

    // Linux cleanup
    _audioQueue.clear();
    await _linuxSubscription?.cancel();
    _linuxSubscription = null;
    _linuxProcess?.kill();
    _linuxProcess = null;

    await _recognizer?.dispose();
    _recognizer = null;
    _model?.dispose();
    _model = null;

    _isCalibrating = false;
    _isDrainingQueue = false;
    _stopped = false;
  }

  Future<void> dispose() => stop();

  // ── Android path ───────────────────────────────────────────────────────────

  void _handleSpeechServiceResult(String json) {
    if (_stopped) return;
    _checkResult(json, DateTime.now());
  }

  // ── Linux path ─────────────────────────────────────────────────────────────

  Future<void> _startLinux() async {
    _linuxProcess = await Process.start('parec', [
      '--format=s16le',
      '--rate=16000',
      '--channels=1',
    ]);
    _linuxSubscription =
        _linuxProcess!.stdout.listen((chunk) => _handleChunk(chunk));
  }

  void _handleChunk(List<int> chunk) {
    if (_stopped || _recognizer == null || chunk.length < 2) return;

    final bytes = chunk is Uint8List ? chunk : Uint8List.fromList(chunk);
    final samples = bytes.buffer.asInt16List();
    final rms = _computeRms(samples);
    final now = DateTime.now();

    if (_isCalibrating) {
      _calibrationSum += rms;
      _calibrationCount++;
      if (now.isAfter(_calibrationEnd!)) {
        _ambientBaseline = _calibrationCount > 0
            ? max(_calibrationSum / _calibrationCount, 0.005)
            : 0.005;
        _isCalibrating = false;
        _onCalibrationDone?.call();
      }
      return;
    }

    if (_suppressedUntil != null && now.isBefore(_suppressedUntil!)) {
      _audioQueue.clear();
      _wasAboveGate = false;
      return;
    }

    final isAboveGate = rms >= _ambientBaseline * _kAmbientMultiplier;

    if (!isAboveGate) {
      if (_wasAboveGate) {
        // Utterance just ended: send silence so Vosk's endpointer fires.
        _wasAboveGate = false;
        if (_audioQueue.length < _kMaxQueueSize) {
          _audioQueue.add(_kSilenceBuffer);
          _drainQueue();
        }
      } else {
        _audioQueue.clear();
      }
      return;
    }

    _wasAboveGate = true;

    if (_audioQueue.length < _kMaxQueueSize) {
      _audioQueue.add(bytes);
      _drainQueue();
    }
  }

  Future<void> _drainQueue() async {
    if (_isDrainingQueue) return;
    _isDrainingQueue = true;

    while (_audioQueue.isNotEmpty && !_stopped && _recognizer != null) {
      final bytes = _audioQueue.removeFirst();
      try {
        final accepted = await _recognizer!.acceptWaveformBytes(bytes);
        if (_stopped) break;

        if (accepted) {
          final json = await _recognizer!.getResult();
          if (_stopped) break;
          _checkResult(json, DateTime.now());
        } else {
          final partial = await _recognizer!.getPartialResult();
          if (_stopped) break;
          _checkResult(partial, DateTime.now());
        }
      } catch (e) {
        _onError?.call('Erro Vosk: $e');
        _audioQueue.clear();
        break;
      }
    }

    _isDrainingQueue = false;
  }

  // ── Shared ─────────────────────────────────────────────────────────────────

  void _checkResult(String json, DateTime now) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      // Final result uses "text"; partial result uses "partial".
      final text =
          ((map['text'] ?? map['partial']) as String? ?? '').toLowerCase().trim();

      if (text.isEmpty || text == '[unk]') return;

      if (text.contains('ok') && text.contains('time')) {
        if (_lastDetection == null ||
            now.difference(_lastDetection!) > _kDetectionDebounce) {
          _lastDetection = now;
          _onDetected?.call();
        }
      }
    } catch (_) {}
  }

  double _computeRms(Int16List samples) {
    double sum = 0;
    for (final s in samples) {
      sum += s * s;
    }
    return sqrt(sum / samples.length) / 32768.0;
  }
}
