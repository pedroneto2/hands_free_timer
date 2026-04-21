import 'package:flutter/material.dart';

import '../notifiers/timer_notifier.dart';
import '../services/sound_detector.dart';

class SoundModeSelector extends StatelessWidget {
  final TimerNotifier notifier;

  const SoundModeSelector({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'Sound trigger',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<SoundMode>(
          style: SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          segments: const [
            ButtonSegment(
              value: SoundMode.any,
              icon: Icon(Icons.graphic_eq_rounded),
              label: Text('Any'),
            ),
            ButtonSegment(
              value: SoundMode.whistle,
              icon: Icon(Icons.music_note_rounded),
              label: Text('Whistle'),
            ),
            ButtonSegment(
              value: SoundMode.yell,
              icon: Icon(Icons.record_voice_over_rounded),
              label: Text('Yell'),
            ),
          ],
          selected: {notifier.soundMode},
          onSelectionChanged: (modes) => notifier.setSoundMode(modes.first),
        ),
      ],
    );
  }
}
