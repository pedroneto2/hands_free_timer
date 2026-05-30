import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hands_free_timer/l10n/app_localizations.dart';

import '../main.dart'
    show timerNotifier, themeModeNotifier, saveThemeMode, wakelockNotifier, saveWakelock;
import '../notifiers/timer_notifier.dart';
import '../services/sound_detector.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/language_selector.dart';
import '../widgets/sensitivity_slider.dart';
import '../widgets/sound_mode_selector.dart';
import '../widgets/timer_controls.dart';
import '../widgets/timer_display.dart';
import '../widgets/help_modal.dart' show showHelpModal;
import '../widgets/timer_presets.dart' show showPresetsModal;

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

const _screenChannel = MethodChannel('hands_free_timer/screen');

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TimerNotifier _notifier;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _notifier = timerNotifier;
    _screenChannel.invokeMethod('setKeepBright', wakelockNotifier.value);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _notifier.addListener(_onNotifierChange);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onNotifierChange() {
    _syncAnimation();
    final err = _notifier.voiceInitError;
    if (err != null) {
      _notifier.clearVoiceInitError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 6),
            ),
          );
        }
      });
    }
  }

  void _syncAnimation() {
    final shouldPulse = _notifier.isRunning || _notifier.soundActivated;
    if (shouldPulse) {
      if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _pulseController.stop();
    } else if (state == AppLifecycleState.resumed) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifier.removeListener(_onNotifierChange);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Scaffold and AppBar are outside ListenableBuilder so they are not
    // rebuilt on every timer tick (every second). Only the body content,
    // which actually changes, is rebuilt by the notifier.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: wakelockNotifier,
            builder: (context, enabled, _) => IconButton(
              icon: Icon(
                enabled ? Icons.wb_sunny_rounded : Icons.bedtime_rounded,
              ),
              onPressed: () {
                final next = !enabled;
                wakelockNotifier.value = next;
                _screenChannel.invokeMethod('setKeepBright', next);
                saveWakelock(next);
              },
              color: enabled ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, themeMode, _) => IconButton(
              icon: const Icon(Icons.contrast_rounded),
              onPressed: () {
                final next = themeMode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;
                themeModeNotifier.value = next;
                saveThemeMode(next);
              },
              color: cs.onSurfaceVariant,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () => showLanguageSelector(context),
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: BannerAdWidget(),
      ),
      body: ListenableBuilder(
        listenable: _notifier,
        child: TextButton.icon(
          onPressed: () => showHelpModal(context),
          icon: const Icon(Icons.help_outline_rounded, size: 15),
          label: Text(
            AppLocalizations.of(context)!.helpButton,
            style: const TextStyle(fontSize: 13),
          ),
          style: TextButton.styleFrom(
            foregroundColor: cs.onSurfaceVariant,
          ),
        ),
        builder: (context, helpButton) => Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // RepaintBoundary isolates the timer circle's repaints
                    // (every second) from the surrounding render layers.
                    RepaintBoundary(
                      child: TimerDisplay(
                        notifier: _notifier,
                        pulseAnimation: _pulseAnimation,
                        onTap: _notifier.isRunning
                            ? null
                            : () => showPresetsModal(context, _notifier),
                      ),
                    ),
                    const SizedBox(height: 36),
                    TimerControls(notifier: _notifier, pulseAnimation: _pulseAnimation),
                    const SizedBox(height: 20),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _notifier.soundMode != SoundMode.voice
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SensitivitySlider(notifier: _notifier),
                                const SizedBox(height: 14),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    SoundModeSelector(notifier: _notifier),
                    const SizedBox(height: 12),
                    helpButton!,
                  ],
                ),
              ),
            ),
            if (_notifier.isCalibrating)
              Positioned.fill(
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.55),
                    child: Center(child: _CalibrationModal()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CalibrationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: cs.primary, strokeWidth: 3),
          const SizedBox(height: 24),
          Text(
            l10n.voiceCalibrating,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
