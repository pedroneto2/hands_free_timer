import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../notifiers/timer_notifier.dart';
import '../services/sound_detector.dart';

class SoundModeSelector extends StatelessWidget {
  final TimerNotifier notifier;

  const SoundModeSelector({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          l10n.soundTrigger,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<SoundMode>(
          style: SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          segments: [
            ButtonSegment(
              value: SoundMode.any,
              icon: const Icon(Icons.graphic_eq_rounded),
              label: Text(l10n.soundModeAny),
            ),
            ButtonSegment(
              value: SoundMode.whistle,
              icon: const Icon(Icons.music_note_rounded),
              label: Text(l10n.soundModeWhistle),
            ),
            ButtonSegment(
              value: SoundMode.yell,
              icon: const Icon(Icons.record_voice_over_rounded),
              label: Text(l10n.soundModeYell),
            ),
          ],
          selected: {notifier.soundMode},
          onSelectionChanged: (modes) => notifier.setSoundMode(modes.first),
        ),
      ],
    );
  }
}
