import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

void showHelpModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const _HelpDialog(),
  );
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: cs.surfaceContainerHigh,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline_rounded, color: cs.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.helpTitle,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  iconSize: 20,
                  color: cs.onSurfaceVariant,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant, height: 1),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _Section(
                      icon: Icons.touch_app_rounded,
                      title: l.helpTimerCircleTitle,
                      body: l.helpTimerCircleBody,
                    ),
                    _Section(
                      icon: Icons.timer_outlined,
                      title: l.helpPresetsTitle,
                      body: l.helpPresetsBody,
                    ),
                    _Section(
                      icon: Icons.play_circle_outline_rounded,
                      title: l.helpControlsTitle,
                      body: l.helpControlsBody,
                    ),
                    _Section(
                      icon: Icons.graphic_eq_rounded,
                      title: l.helpSoundTriggerTitle,
                      body: l.helpSoundTriggerBody,
                    ),
                    _Section(
                      icon: Icons.tune_rounded,
                      title: l.helpSensitivityTitle,
                      body: l.helpSensitivityBody,
                    ),
                    _Section(
                      icon: Icons.wb_sunny_outlined,
                      title: l.helpScreenTitle,
                      body: l.helpScreenBody,
                    ),
                    _Section(
                      icon: Icons.language_rounded,
                      title: l.helpLanguageTitle,
                      body: l.helpLanguageBody,
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool last;

  const _Section({
    required this.icon,
    required this.title,
    required this.body,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: cs.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
        if (!last) ...[
          const SizedBox(height: 14),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.5), height: 1),
        ],
      ],
    );
  }
}
