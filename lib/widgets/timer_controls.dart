import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class TimerControls extends StatefulWidget {
  final TimerNotifier notifier;
  final Animation<double> pulseAnimation;

  const TimerControls({
    required this.notifier,
    required this.pulseAnimation,
    super.key,
  });

  @override
  State<TimerControls> createState() => _TimerControlsState();
}

class _TimerControlsState extends State<TimerControls> {
  static const _kCenterShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  );

  ButtonStyle? _resetStyle;
  ButtonStyle? _centerStyleNormal;
  ButtonStyle? _centerStyleGreen;
  ButtonStyle? _micStyleOn;
  ButtonStyle? _micStyleOff;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    final cs = theme.colorScheme;
    _resetStyle = IconButton.styleFrom(
      foregroundColor: cs.onSurfaceVariant,
      side: BorderSide(color: cs.outlineVariant),
      padding: const EdgeInsets.all(12),
    );
    _centerStyleNormal = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      shape: _kCenterShape,
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
    );
    _centerStyleGreen = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      shape: _kCenterShape,
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.black,
    );
    _micStyleOn = IconButton.styleFrom(
      foregroundColor: cs.primary,
      side: BorderSide(color: cs.primary),
      backgroundColor: cs.primary.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(12),
    );
    _micStyleOff = IconButton.styleFrom(
      foregroundColor: cs.onSurfaceVariant,
      side: BorderSide(color: cs.outlineVariant),
      padding: const EdgeInsets.all(12),
    );
  }

  IconData _centerButtonIcon(bool isGreen) {
    final n = widget.notifier;
    if (isGreen) return Icons.replay_rounded;
    if (n.soundActivated) return Icons.mic;
    return n.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded;
  }

  String _centerButtonLabel(AppLocalizations l, bool isGreen) {
    final n = widget.notifier;
    if (isGreen) return n.soundActivated ? l.btnClapToRestart : l.btnRestart;
    if (n.soundActivated) {
      return n.isRunning ? l.btnClapToPause : l.btnListeningClapToStart;
    }
    return n.isRunning ? l.btnPause : l.btnStart;
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notifier;
    final l = AppLocalizations.of(context)!;
    final isGreen = n.isCompleted;
    final micOn = n.soundActivated;
    final isListening = micOn && !n.isRunning && !isGreen;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          onPressed: n.reset,
          icon: const Icon(Icons.refresh_rounded),
          iconSize: 22,
          style: _resetStyle,
        ),
        const SizedBox(width: 20),
        Flexible(
          child: AnimatedBuilder(
            animation: widget.pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: isListening ? widget.pulseAnimation.value : 1.0,
              child: child,
            ),
            child: FilledButton(
              onPressed: n.startPause,
              style: isGreen ? _centerStyleGreen : _centerStyleNormal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_centerButtonIcon(isGreen), size: 26),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      _centerButtonLabel(l, isGreen),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton.outlined(
          onPressed: n.toggleSoundActivation,
          icon: Icon(micOn ? Icons.mic : Icons.mic_off_rounded),
          iconSize: 22,
          style: micOn ? _micStyleOn : _micStyleOff,
        ),
      ],
    );
  }
}
