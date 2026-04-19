import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../notifiers/timer_notifier.dart';

class TimerPresets extends StatelessWidget {
  final TimerNotifier notifier;

  const TimerPresets({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isCustom = !TimerNotifier.presets.contains(notifier.selectedPreset);

    Widget chip({
      required bool selected,
      required VoidCallback onTap,
      required Widget child,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ...TimerNotifier.presets.map((minutes) {
          final selected = notifier.selectedPreset == minutes &&
              !notifier.isRunning &&
              !notifier.isCompleted;
          return chip(
            selected: selected,
            onTap: () => notifier.selectPreset(minutes),
            child: Text(
              '${minutes}m',
              style: TextStyle(
                color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          );
        }),
        chip(
          selected: isCustom && !notifier.isRunning && !notifier.isCompleted,
          onTap: () {
            if (!notifier.isRunning) _showCustomTimeDialog(context, cs, l);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCustom) ...[
                Icon(Icons.add, size: 13, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
              ],
              Text(
                isCustom
                    ? (notifier.customSeconds != null
                        ? '${notifier.customSeconds}${l.unitSec}'
                        : '${notifier.selectedPreset}${l.unitMin}')
                    : l.presetCustom,
                style: TextStyle(
                  color:
                      (isCustom && !notifier.isRunning && !notifier.isCompleted)
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomTimeDialog(
      BuildContext context, ColorScheme cs, AppLocalizations l) {
    final isCurrentlyCustom =
        !TimerNotifier.presets.contains(notifier.selectedPreset);
    final startInSeconds = notifier.customSeconds != null;
    final controller = TextEditingController(
      text: isCurrentlyCustom
          ? (startInSeconds
              ? '${notifier.customSeconds}'
              : '${notifier.selectedPreset}')
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        bool isSeconds = startInSeconds;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
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
                    suffix: GestureDetector(
                      onTap: () =>
                          setDialogState(() => isSeconds = !isSeconds),
                      child: Text(
                        isSeconds ? l.unitSec : l.unitMin,
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: cs.primary,
                        ),
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onSubmitted: (_) =>
                      _confirmCustomTime(ctx, controller, isSeconds),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.dialogCancel,
                    style: TextStyle(color: cs.onSurfaceVariant)),
              ),
              FilledButton(
                onPressed: () =>
                    _confirmCustomTime(ctx, controller, isSeconds),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l.dialogSet),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmCustomTime(
      BuildContext ctx, TextEditingController controller, bool isSeconds) {
    final value = int.tryParse(controller.text.trim());
    if (value == null || value < 1) return;
    if (isSeconds && value <= 3600) {
      notifier.selectBySeconds(value);
      Navigator.pop(ctx);
    } else if (!isSeconds && value <= 180) {
      notifier.selectPreset(value);
      Navigator.pop(ctx);
    }
  }
}
