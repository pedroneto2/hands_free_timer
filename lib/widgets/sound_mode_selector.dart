import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../notifiers/timer_notifier.dart';
import '../services/sound_detector.dart';

class SoundModeSelector extends StatefulWidget {
  final TimerNotifier notifier;

  const SoundModeSelector({required this.notifier, super.key});

  @override
  State<SoundModeSelector> createState() => _SoundModeSelectorState();
}

class _SoundModeSelectorState extends State<SoundModeSelector> {
  static const _kSelectedAny     = {SoundMode.any};
  static const _kSelectedWhistle = {SoundMode.whistle};
  static const _kSelectedYell    = {SoundMode.yell};
  static const _kSegmentedStyle  = ButtonStyle(visualDensity: VisualDensity.compact);

  TextStyle? _labelStyle;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    _labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  void _onSelectionChanged(Set<SoundMode> modes) {
    if (modes.isNotEmpty) widget.notifier.setSoundMode(modes.first);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isVoice = widget.notifier.soundMode == SoundMode.voice;

    return Column(
      children: [
        Text(l10n.soundTrigger, style: _labelStyle),
        const SizedBox(height: 8),
        SegmentedButton<SoundMode>(
          style: _kSegmentedStyle,
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
          selected: isVoice
              ? const <SoundMode>{}
              : switch (widget.notifier.soundMode) {
                  SoundMode.any     => _kSelectedAny,
                  SoundMode.whistle => _kSelectedWhistle,
                  SoundMode.yell    => _kSelectedYell,
                  SoundMode.voice   => const <SoundMode>{},
                },
          emptySelectionAllowed: true,
          onSelectionChanged: _onSelectionChanged,
        ),
        const SizedBox(height: 8),
        _VoiceModeButton(notifier: widget.notifier, isSelected: isVoice),
      ],
    );
  }
}

class _VoiceModeButton extends StatefulWidget {
  final TimerNotifier notifier;
  final bool isSelected;

  const _VoiceModeButton({
    required this.notifier,
    required this.isSelected,
  });

  @override
  State<_VoiceModeButton> createState() => _VoiceModeButtonState();
}

class _VoiceModeButtonState extends State<_VoiceModeButton> {
  static const _kShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  ButtonStyle? _selectedStyle;
  ButtonStyle? _unselectedStyle;
  TextStyle? _selectedTextStyle;
  TextStyle? _unselectedTextStyle;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    final cs = theme.colorScheme;
    _selectedTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: cs.primary,
    );
    _unselectedTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: cs.onSurfaceVariant,
    );
    _selectedStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      side: BorderSide(color: cs.primary, width: 2),
      backgroundColor: cs.primary.withValues(alpha: 0.12),
      shape: _kShape,
    );
    _unselectedStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      side: BorderSide(color: cs.outlineVariant),
      shape: _kShape,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cachedTheme!.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isSelected = widget.isSelected;

    return OutlinedButton.icon(
      onPressed: () => widget.notifier.setSoundMode(SoundMode.voice),
      icon: Icon(
        Icons.mic_rounded,
        size: 18,
        color: isSelected ? cs.primary : cs.onSurfaceVariant,
      ),
      label: Text(
        l10n.soundModeVoice,
        style: isSelected ? _selectedTextStyle : _unselectedTextStyle,
      ),
      style: isSelected ? _selectedStyle : _unselectedStyle,
    );
  }
}
