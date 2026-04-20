import 'package:flutter/material.dart';
import 'package:hands_free_timer/l10n/app_localizations.dart';

class AdSplashScreen extends StatefulWidget {
  final ValueNotifier<bool> adLoadedNotifier;
  final Future<void> Function(BuildContext context, VoidCallback onDismissed) showAd;
  final VoidCallback onClosed;

  const AdSplashScreen({
    super.key,
    required this.adLoadedNotifier,
    required this.showAd,
    required this.onClosed,
  });

  @override
  State<AdSplashScreen> createState() => _AdSplashScreenState();
}

class _AdSplashScreenState extends State<AdSplashScreen> {
  bool _adShowing = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    widget.adLoadedNotifier.addListener(_onAdStatusChanged);
    if (widget.adLoadedNotifier.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onAdStatusChanged());
    }
  }

  void _onAdStatusChanged() {
    if (!mounted || _adShowing || _dismissed) return;
    if (widget.adLoadedNotifier.value) {
      _adShowing = true;
      widget.showAd(context, _close);
    }
  }

  void _close() {
    if (_dismissed) return;
    _dismissed = true;
    widget.onClosed();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    widget.adLoadedNotifier.removeListener(_onAdStatusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.timer_rounded, size: 80, color: cs.primary),
              const SizedBox(height: 16),
              Text(
                l10n.appTitle,
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(color: cs.primary),
              const SizedBox(height: 12),
              Text(
                'Loading ad…',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: FilledButton.tonal(
                  onPressed: _close,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Continue to App'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
