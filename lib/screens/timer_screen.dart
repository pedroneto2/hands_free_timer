import 'package:flutter/material.dart';

import '../notifiers/timer_notifier.dart';
import '../widgets/sensitivity_slider.dart';
import '../widgets/timer_controls.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_presets.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TimerNotifier _notifier;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _notifier = TimerNotifier();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _notifier.addListener(_syncAnimation);
    WidgetsBinding.instance.addObserver(this);
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
      // Window hidden or screen off — stop animation to save CPU/GPU.
      _pulseController.stop();
    } else if (state == AppLifecycleState.resumed) {
      // Window visible again — restore animation if needed.
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifier.removeListener(_syncAnimation);
    _notifier.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) => Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Hands Free Timer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              TimerDisplay(notifier: _notifier, pulseAnimation: _pulseAnimation),
              const SizedBox(height: 44),
              TimerPresets(notifier: _notifier),
              const SizedBox(height: 44),
              TimerControls(notifier: _notifier, pulseAnimation: _pulseAnimation),
              const SizedBox(height: 24),
              SensitivitySlider(notifier: _notifier),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
