import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class SensitivitySlider extends StatelessWidget {
  final TimerNotifier notifier;

  const SensitivitySlider({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
      child: Column(
        children: [
          Text(
            l.micSensitivity,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(l.sensitivityLow,
                  style:
                      TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    activeTrackColor: cs.primary,
                    inactiveTrackColor: cs.surfaceContainerHighest,
                    thumbColor: cs.primary,
                    overlayColor: cs.primary.withValues(alpha: 0.12),
                  ),
                  child: Slider(
                    value: notifier.sensitivity,
                    onChanged: notifier.setSensitivity,
                  ),
                ),
              ),
              Text(l.sensitivityHigh,
                  style:
                      TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}
