import 'package:flutter/material.dart';

import '../notifiers/timer_notifier.dart';

class SensitivitySlider extends StatelessWidget {
  final TimerNotifier notifier;

  const SensitivitySlider({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
      child: Column(
        children: [
          Text(
            'MIC SENSITIVITY',
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
              Text('Low',
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
              Text('High',
                  style:
                      TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}
