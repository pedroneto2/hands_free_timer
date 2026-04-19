import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../main.dart' show localeNotifier;

const _languages = [
  (locale: Locale('en'),        nativeName: 'English'),
  (locale: Locale('pt', 'BR'), nativeName: 'Português (Brasil)'),
  (locale: Locale('zh'),        nativeName: '中文'),
  (locale: Locale('es'),        nativeName: 'Español'),
  (locale: Locale('hi'),        nativeName: 'हिन्दी'),
  (locale: Locale('ar'),        nativeName: 'العربية'),
  (locale: Locale('fr'),        nativeName: 'Français'),
  (locale: Locale('bn'),        nativeName: 'বাংলা'),
  (locale: Locale('id'),        nativeName: 'Bahasa Indonesia'),
  (locale: Locale('ur'),        nativeName: 'اردو'),
];

void showLanguageSelector(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final l = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: cs.surfaceContainerHigh,
      title: Text(
        l.selectLanguage,
        style: TextStyle(
          fontSize: 13,
          letterSpacing: 1.5,
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: 280,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _languages.length,
          itemBuilder: (_, i) {
            final lang = _languages[i];
            final selected = localeNotifier.value == lang.locale;
            return ListTile(
              title: Text(
                lang.nativeName,
                style: TextStyle(
                  color: selected ? cs.primary : cs.onSurface,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: selected
                  ? Icon(Icons.check_rounded, color: cs.primary, size: 20)
                  : null,
              onTap: () {
                localeNotifier.value = lang.locale;
                Navigator.pop(ctx);
              },
            );
          },
        ),
      ),
    ),
  );
}
