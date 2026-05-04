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
    final isVoice = notifier.soundMode == SoundMode.voice;

    return Column(
      children: [
        Text(
          l10n.soundTrigger,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        // Row 1: Any | Whistle | Yell
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
          // When voice mode is active, none of these three are selected.
          selected: isVoice ? const <SoundMode>{} : {notifier.soundMode},
          emptySelectionAllowed: true,
          onSelectionChanged: (modes) {
            if (modes.isNotEmpty) notifier.setSoundMode(modes.first);
          },
        ),
        const SizedBox(height: 8),
        // Row 2: Voice Command (Ok Time)
        _VoiceModeButton(notifier: notifier, isSelected: isVoice),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: isVoice
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.battery_alert_rounded,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.voiceBatteryHint,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _VoiceModeButton extends StatelessWidget {
  final TimerNotifier notifier;
  final bool isSelected;

  const _VoiceModeButton({
    required this.notifier,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return OutlinedButton.icon(
      onPressed: () => notifier.setSoundMode(SoundMode.voice),
      icon: Icon(
        Icons.mic_rounded,
        size: 18,
        color: isSelected ? cs.primary : cs.onSurfaceVariant,
      ),
      label: Text(
        l10n.soundModeVoice,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        side: BorderSide(
          color: isSelected ? cs.primary : cs.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor:
            isSelected ? cs.primary.withValues(alpha: 0.12) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
