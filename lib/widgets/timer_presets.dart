import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

String _fmtSeconds(int s, AppLocalizations l) {
  if (s < 60) return '$s${l.unitSec}';
  final m = s ~/ 60;
  final rem = s % 60;
  if (rem == 0) return '$m${l.unitMin}';
  return '${m}m ${rem}s';
}

void showPresetsModal(BuildContext context, TimerNotifier notifier) {
  showDialog(
    context: context,
    builder: (_) => _PresetsDialog(notifier: notifier),
  );
}

const _kDialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(24)),
);

class _PresetsDialog extends StatefulWidget {
  final TimerNotifier notifier;

  const _PresetsDialog({required this.notifier});

  @override
  State<_PresetsDialog> createState() => _PresetsDialogState();
}

class _PresetsDialogState extends State<_PresetsDialog> {
  int _prevSelectedPreset = -1;
  int? _prevCustomSeconds;
  bool _prevIsRunning = false;
  bool _prevIsCompleted = false;
  int _prevCustomPresetsLen = 0;
  int _prevHiddenLen = 0;

  @override
  void initState() {
    super.initState();
    _syncPrevValues();
    widget.notifier.addListener(_onNotifierChanged);
  }

  void _syncPrevValues() {
    final n = widget.notifier;
    _prevSelectedPreset = n.selectedPreset;
    _prevCustomSeconds = n.customSeconds;
    _prevIsRunning = n.isRunning;
    _prevIsCompleted = n.isCompleted;
    _prevCustomPresetsLen = n.customPresets.length;
    _prevHiddenLen = n.hiddenBuiltInPresets.length;
  }

  void _onNotifierChanged() {
    final n = widget.notifier;
    if (n.selectedPreset != _prevSelectedPreset ||
        n.customSeconds != _prevCustomSeconds ||
        n.isRunning != _prevIsRunning ||
        n.isCompleted != _prevIsCompleted ||
        n.customPresets.length != _prevCustomPresetsLen ||
        n.hiddenBuiltInPresets.length != _prevHiddenLen) {
      _syncPrevValues();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotifierChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notifier;
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final hidden = n.hiddenBuiltInPresets;

    return Dialog(
      shape: _kDialogShape,
      backgroundColor: cs.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ...TimerNotifier.presets
                    .where((m) => !hidden.contains(m))
                    .map((minutes) {
                  final selected = n.customSeconds == null &&
                      n.selectedPreset == minutes &&
                      !n.isRunning &&
                      !n.isCompleted;
                  return _CustomChip(
                    label: '$minutes${l.unitMin}',
                    selected: selected,
                    onTap: () {
                      n.selectPreset(minutes);
                      Navigator.pop(context);
                    },
                    onDelete: () => n.hideBuiltInPreset(minutes),
                  );
                }),
                ...n.customPresets.map((seconds) {
                  final selected = n.customSeconds == seconds &&
                      !n.isRunning &&
                      !n.isCompleted;
                  return _CustomChip(
                    label: _fmtSeconds(seconds, l),
                    selected: selected,
                    onTap: () {
                      n.selectBySeconds(seconds);
                      Navigator.pop(context);
                    },
                    onDelete: () => n.removeCustomPreset(seconds),
                  );
                }),
                _AddChip(
                  label: l.presetCustom,
                  onTap: () => _showCustomTimeDialog(context, cs, l, n),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CustomChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<_CustomChip> {
  static const _kBorderRadius = BorderRadius.all(Radius.circular(20));

  BoxDecoration? _selectedDecoration;
  BoxDecoration? _unselectedDecoration;
  TextStyle? _selectedTextStyle;
  TextStyle? _unselectedTextStyle;
  Color? _selectedIconColor;
  Color? _unselectedIconColor;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    final cs = theme.colorScheme;
    _selectedDecoration = BoxDecoration(
      color: cs.primary,
      borderRadius: _kBorderRadius,
    );
    _unselectedDecoration = BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: _kBorderRadius,
    );
    _selectedTextStyle = TextStyle(
      color: cs.onPrimary,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    _unselectedTextStyle = TextStyle(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    _selectedIconColor = cs.onPrimary.withValues(alpha: 0.65);
    _unselectedIconColor = cs.onSurfaceVariant.withValues(alpha: 0.55);
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: sel ? _selectedDecoration : _unselectedDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 14, top: 9, bottom: 9, right: 6),
              child: Text(
                widget.label,
                style: sel ? _selectedTextStyle : _unselectedTextStyle,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onDelete,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 9, bottom: 9, left: 2),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: sel ? _selectedIconColor : _unselectedIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _AddChip({required this.label, required this.onTap});

  @override
  State<_AddChip> createState() => _AddChipState();
}

class _AddChipState extends State<_AddChip> {
  static const _kBorderRadius = BorderRadius.all(Radius.circular(20));

  BoxDecoration? _decoration;
  TextStyle? _textStyle;
  Color? _iconColor;
  ThemeData? _cachedTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    if (identical(theme, _cachedTheme)) return;
    _cachedTheme = theme;
    final cs = theme.colorScheme;
    _decoration = BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: _kBorderRadius,
      border: Border.all(
        color: cs.outline.withValues(alpha: 0.35),
        width: 1,
      ),
    );
    _textStyle = TextStyle(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    _iconColor = cs.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: _decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 14, color: _iconColor),
            const SizedBox(width: 5),
            Text(widget.label, style: _textStyle),
          ],
        ),
      ),
    );
  }
}

void _showCustomTimeDialog(
  BuildContext sheetContext,
  ColorScheme cs,
  AppLocalizations l,
  TimerNotifier notifier,
) {
  bool isSeconds = false;
  final controller = TextEditingController();

  Widget unitToggle(StateSetter setDialogState) {
    Widget option(String label, bool selected) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? cs.onPrimary : cs.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

    return GestureDetector(
      onTap: () => setDialogState(() => isSeconds = !isSeconds),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            option(l.unitMin, !isSeconds),
            option(l.unitSec, isSeconds),
          ],
        ),
      ),
    );
  }

  showDialog(
    context: sheetContext,
    builder: (dialogCtx) => StatefulBuilder(
      builder: (dialogCtx, setDialogState) {
        void confirm() {
          final value = int.tryParse(controller.text.trim());
          if (value == null || value < 1) return;
          int? seconds;
          if (isSeconds && value <= 3600) {
            seconds = value;
          } else if (!isSeconds && value <= 180) {
            seconds = value * 60;
          }
          if (seconds == null) return;
          notifier.addCustomPreset(seconds);
          Navigator.pop(dialogCtx);
          Navigator.pop(sheetContext);
        }

        return AlertDialog(
          shape: _kDialogShape,
          backgroundColor: cs.surfaceContainerHigh,
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.dialogCustomDuration,
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                  color: cs.onSurface,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: isSeconds ? '90' : '25',
                  hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2,
                  ),
                  suffix: unitToggle(setDialogState),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onSubmitted: (_) => confirm(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(l.dialogCancel,
                  style: TextStyle(color: cs.onSurfaceVariant)),
            ),
            FilledButton(
              onPressed: confirm,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l.dialogSet),
            ),
          ],
        );
      },
    ),
  ).then((_) => controller.dispose());
}
