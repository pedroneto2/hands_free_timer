import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class TimerControls extends StatelessWidget {
  final TimerNotifier notifier;
  final Animation<double> pulseAnimation;

  const TimerControls({
    required this.notifier,
    required this.pulseAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isGreen = notifier.isCompleted;
    final isListening =
        notifier.soundActivated && !notifier.isRunning && !isGreen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          onPressed: notifier.reset,
          icon: const Icon(Icons.refresh_rounded),
          iconSize: 26,
          style: IconButton.styleFrom(
            foregroundColor: cs.onSurfaceVariant,
            side: BorderSide(color: cs.outlineVariant),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(width: 24),
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) => Transform.scale(
            scale: isListening ? pulseAnimation.value : 1.0,
            child: child,
          ),
          child: FilledButton(
            onPressed: notifier.startPause,
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              backgroundColor: isGreen ? Colors.greenAccent : cs.primary,
              foregroundColor: isGreen ? Colors.black : cs.onPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_centerButtonIcon(isGreen), size: 26),
                const SizedBox(width: 8),
                Text(
                  _centerButtonLabel(context, isGreen),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        IconButton.outlined(
          onPressed: () => notifier.toggleSoundActivation(),
          icon: Icon(
            notifier.soundActivated ? Icons.mic : Icons.mic_off_rounded,
          ),
          iconSize: 26,
          style: IconButton.styleFrom(
            foregroundColor:
                notifier.soundActivated ? cs.primary : cs.onSurfaceVariant,
            side: BorderSide(
              color:
                  notifier.soundActivated ? cs.primary : cs.outlineVariant,
            ),
            backgroundColor: notifier.soundActivated
                ? cs.primary.withValues(alpha: 0.12)
                : null,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  IconData _centerButtonIcon(bool isGreen) {
    if (isGreen) return Icons.replay_rounded;
    if (notifier.soundActivated) return Icons.mic;
    return notifier.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded;
  }

  String _centerButtonLabel(BuildContext context, bool isGreen) {
    final l = AppLocalizations.of(context)!;
    if (isGreen) return notifier.soundActivated ? l.btnClapToRestart : l.btnRestart;
    if (notifier.soundActivated) {
      return notifier.isRunning ? l.btnClapToPause : l.btnListeningClapToStart;
    }
    return notifier.isRunning ? l.btnPause : l.btnStart;
  }
}
