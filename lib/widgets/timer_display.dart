import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class TimerDisplay extends StatefulWidget {
  final TimerNotifier notifier;
  final Animation<double> pulseAnimation;
  final VoidCallback? onTap;

  const TimerDisplay({
    required this.notifier,
    required this.pulseAnimation,
    this.onTap,
    super.key,
  });

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  ThemeData? _cachedTheme;
  TextStyle? _hintStyle;
  TextStyle? _timeStyle;
  TextStyle? _statusStyleNormal;
  TextStyle? _statusStyleCompleted;
  TextStyle? _presetStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    final cs = theme.colorScheme;
    final dimColor = cs.onSurfaceVariant.withValues(alpha: 0.45);
    _hintStyle = TextStyle(
      fontSize: 9,
      letterSpacing: 1.2,
      color: dimColor,
      fontWeight: FontWeight.w400,
    );
    _timeStyle = TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.w200,
      color: cs.onSurface,
      letterSpacing: 2,
    );
    _statusStyleNormal = TextStyle(
      fontSize: 13,
      letterSpacing: 1.8,
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );
    _statusStyleCompleted = const TextStyle(
      fontSize: 13,
      letterSpacing: 1.8,
      color: Colors.greenAccent,
      fontWeight: FontWeight.w500,
    );
    _presetStyle = TextStyle(
      fontSize: 10,
      color: dimColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    );
  }

  String _statusText(AppLocalizations l) {
    return switch (widget.notifier.status) {
      TimerStatus.completed => l.statusDone,
      TimerStatus.running   => l.statusRunning,
      TimerStatus.ready     => l.statusReady,
      TimerStatus.paused    => l.statusPaused,
    };
  }

  String _presetLabel(AppLocalizations l) {
    final cs = widget.notifier.customSeconds;
    if (cs != null) {
      if (cs < 60) return '$cs${l.unitSec}';
      final m = cs ~/ 60;
      final rem = cs % 60;
      if (rem == 0) return '$m${l.unitMin}';
      return '${m}m ${rem}s';
    }
    return '${widget.notifier.selectedPreset}${l.unitMin}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cachedTheme!.colorScheme;
    final l = AppLocalizations.of(context)!;
    final notifier = widget.notifier;

    return AnimatedBuilder(
      animation: widget.pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: notifier.isRunning ? widget.pulseAnimation.value : 1.0,
        child: child,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
        width: 210,
        height: 210,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(210, 210),
              painter: _CircularTimerPainter(
                progress: notifier.progress,
                trackColor: cs.surfaceContainerHighest,
                progressColor:
                    notifier.isCompleted ? Colors.greenAccent : cs.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: !notifier.isRunning && !notifier.isCompleted,
                  child: Text(
                    'touch to select',
                    style: _hintStyle,
                  ),
                ),
                const SizedBox(height: 2),
                if (notifier.isCompleted)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.greenAccent, size: 40)
                else
                  Text(
                    notifier.timeDisplay,
                    style: _timeStyle,
                  ),
                const SizedBox(height: 4),
                Text(
                  _statusText(l),
                  style: notifier.isCompleted
                      ? _statusStyleCompleted
                      : _statusStyleNormal,
                ),
                const SizedBox(height: 3),
                Text(
                  _presetLabel(l),
                  style: _presetStyle,
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  static const _strokeWidth = 14.0;

  final Paint _trackPaint;
  final Paint _arcPaint;

  _CircularTimerPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  })  : _trackPaint = Paint()
          ..color = trackColor
          ..strokeWidth = _strokeWidth
          ..style = PaintingStyle.stroke,
        _arcPaint = Paint()
          ..color = progressColor
          ..strokeWidth = _strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - _strokeWidth / 2;

    canvas.drawCircle(center, radius, _trackPaint);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        _arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularTimerPainter old) =>
      old.progress != progress ||
      old.progressColor != progressColor ||
      old.trackColor != trackColor;
}
