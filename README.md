# Hands Free Timer

A beautiful countdown timer you control with your voice — no screen taps needed.
Clap or make any sound to start, pause, and restart the timer. Built with Flutter.

---

## Features

- **Hands-free control** — Make a sound to start/pause the countdown
- **Adjustable mic sensitivity** — fine-tune the detection threshold with a slider
- **Preset durations** — quick-select 1 m, 5 m, 10 m, 15 m, 30 m
- **Custom duration** — enter any value in minutes or seconds
- **Completion alert** — plays a chime and wakes the screen when time is up
- **10 languages** — English, Português (Brasil), 中文, Español, हिन्दी, العربية, Français, বাংলা, Bahasa Indonesia, اردو
- **Battery-friendly** — animation pauses when the window is hidden; screen wake on demand only

## Platforms

| Platform | Status |
|---|---|
| Android | Supported |
| iOS | Supported |
| Linux desktop | Supported (primary development target) |

## Requirements

- Flutter SDK ≥ 3.11
- Dart SDK ≥ 3.11
- **Linux:** PulseAudio (`parec`, `paplay`) — provided by default on most distros and via WSLg on WSL2
- **Android/iOS:** Microphone permission granted at runtime

## Project Structure

```
lib/
├── main.dart                  # App entry point, locale notifier
├── notifiers/
│   └── timer_notifier.dart    # All timer logic (ChangeNotifier)
├── screens/
│   └── timer_screen.dart      # Root screen, animation orchestration
├── services/
│   ├── sound_detector.dart    # Mic input via parec subprocess + RMS detection
│   └── sound_player.dart      # Completion chime (in-memory WAV via paplay)
├── widgets/
│   ├── timer_display.dart     # Circular progress ring + time readout
│   ├── timer_controls.dart    # Start/pause button + mic toggle + reset
│   ├── timer_presets.dart     # Duration chips + custom time dialog
│   ├── sensitivity_slider.dart
│   └── language_selector.dart
└── l10n/                      # ARB translation files + generated localizations
```

## Building

```bash
# Get dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on Linux desktop
flutter run -d linux

# Build release APK (Android)
flutter build apk --release

# Build for iOS (requires macOS + Xcode)
flutter build ios --release
```

## Privacy

This app uses the microphone exclusively for on-device sound detection.
No audio is ever recorded, stored, or transmitted.
Full privacy policy: [docs/privacy_policy.html](docs/privacy_policy.html)

## License

Copyright (c) 2025 Pedro Barbosa. All Rights Reserved.

This is proprietary software. Viewing this source does not grant any right
to use, copy, modify, or distribute it. See [LICENSE](LICENSE) for full terms.

Licensing inquiries: pedro.neto992@gmail.com
