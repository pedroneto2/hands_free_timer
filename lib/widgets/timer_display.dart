import 'dart:math';

import 'package:flutter/material.dart';

import '../notifiers/timer_notifier.dart';

class TimerDisplay extends StatelessWidget {
  final TimerNotifier notifier;
  final Animation<double> pulseAnimation;

  const TimerDisplay({
    required this.notifier,
    required this.pulseAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: notifier.isRunning ? pulseAnimation.value : 1.0,
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
                progress: notifier.progress,
                trackColor: cs.surfaceContainerHighest,
                progressColor:
                    notifier.isCompleted ? Colors.greenAccent : cs.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (notifier.isCompleted)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.greenAccent, size: 52)
                else
                  Text(
                    notifier.timeDisplay,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w200,
                      color: cs.onSurface,
                      letterSpacing: 2,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  notifier.statusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1.8,
                    color: notifier.isCompleted
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
