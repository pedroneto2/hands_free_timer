import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  static const List<int> _presets = [1, 5, 10, 15, 25, 30];

  int _selectedPreset = 25;
  int _totalSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;

  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _selectPreset(int minutes) {
    if (_isRunning) return;
    setState(() {
      _selectedPreset = minutes;
      _totalSeconds = minutes * 60;
      _remainingSeconds = minutes * 60;
      _isCompleted = false;
    });
  }

  void _startPause() {
    if (_isCompleted) {
      _reset();
      return;
    }
    _isRunning ? _pause() : _start();
  }

  void _start() {
    WakelockPlus.enable();
    _pulseController.repeat(reverse: true);
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _onComplete();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _pause() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    WakelockPlus.disable();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    WakelockPlus.disable();
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _onComplete() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    WakelockPlus.disable();
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 300), HapticFeedback.heavyImpact);
    Future.delayed(const Duration(milliseconds: 600), HapticFeedback.heavyImpact);
    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _remainingSeconds = 0;
    });
  }

  String get _timeDisplay {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      _totalSeconds == 0 ? 0 : 1.0 - (_remainingSeconds / _totalSeconds);

  String get _statusLabel {
    if (_isCompleted) return 'Done!';
    if (_isRunning) return 'Running';
    return _remainingSeconds == _totalSeconds ? 'Ready' : 'Paused';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Hands Free Timer',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            _buildTimerDisplay(cs),
            const SizedBox(height: 44),
            _buildPresets(cs),
            const SizedBox(height: 44),
            _buildControls(cs),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(ColorScheme cs) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _isRunning ? _pulseAnimation.value : 1.0,
        child: child,
      ),
      child: SizedBox(
        width: 264,
        height: 264,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(264, 264),
              painter: _CircularTimerPainter(
                progress: _progress,
                trackColor: cs.surfaceContainerHighest,
                progressColor: _isCompleted ? Colors.greenAccent : cs.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isCompleted)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.greenAccent, size: 52)
                else
                  Text(
                    _timeDisplay,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w200,
                      color: cs.onSurface,
                      letterSpacing: 2,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1.8,
                    color: _isCompleted
                        ? Colors.greenAccent
                        : cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresets(ColorScheme cs) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: _presets.map((minutes) {
        final selected = _selectedPreset == minutes && !_isRunning && !_isCompleted;
        return GestureDetector(
          onTap: () => _selectPreset(minutes),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: selected
                  ? cs.primary
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${minutes}m',
              style: TextStyle(
                color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildControls(ColorScheme cs) {
    final isGreen = _isCompleted;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          onPressed: _reset,
          icon: const Icon(Icons.refresh_rounded),
          iconSize: 26,
          style: IconButton.styleFrom(
            foregroundColor: cs.onSurfaceVariant,
            side: BorderSide(color: cs.outlineVariant),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(width: 24),
        FilledButton(
          onPressed: _startPause,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            backgroundColor: isGreen ? Colors.greenAccent : cs.primary,
            foregroundColor: isGreen ? Colors.black : cs.onPrimary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isGreen
                    ? Icons.replay_rounded
                    : (_isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded),
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                isGreen ? 'Restart' : (_isRunning ? 'Pause' : 'Start'),
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  const _CircularTimerPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularTimerPainter old) =>
      old.progress != progress || old.progressColor != progressColor;
}
