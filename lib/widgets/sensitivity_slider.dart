import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class SensitivitySlider extends StatefulWidget {
  final TimerNotifier notifier;

  const SensitivitySlider({required this.notifier, super.key});

  @override
  State<SensitivitySlider> createState() => _SensitivitySliderState();
}

class _SensitivitySliderState extends State<SensitivitySlider> {
  SliderThemeData? _sliderTheme;
  TextStyle? _labelStyle;
  TextStyle? _endLabelStyle;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (!identical(theme, _cachedTheme)) {
      _cachedTheme = theme;
      final cs = theme.colorScheme;
      _sliderTheme = SliderTheme.of(context).copyWith(
        trackHeight: 2,
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceContainerHighest,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha: 0.12),
      );
      _labelStyle = TextStyle(
        fontSize: 11,
        letterSpacing: 2,
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      );
      _endLabelStyle = TextStyle(fontSize: 11, color: cs.onSurfaceVariant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
      child: Column(
        children: [
          Text(l.micSensitivity, style: _labelStyle),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(l.sensitivityLow, style: _endLabelStyle),
              Expanded(
                child: SliderTheme(
                  data: _sliderTheme!,
                  child: Slider(
                    value: widget.notifier.sensitivity,
                    onChanged: widget.notifier.setSensitivity,
                  ),
                ),
              ),
              Text(l.sensitivityHigh, style: _endLabelStyle),
            ],
          ),
        ],
      ),
    );
  }
}
