import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void _foregroundEntryPoint() {
  FlutterForegroundTask.setTaskHandler(_NoopTaskHandler());
}

class _NoopTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}

class ForegroundTimerService {
  static bool get _supported => !kIsWeb && Platform.isAndroid;

  static void init() {
    if (!_supported) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'hands_free_timer_channel',
        channelName: 'Timer',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        enableVibration: false,
        playSound: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
      ),
    );
  }

  static void start(String timeText) {
    if (!_supported) return;
    FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Hands Free Timer',
      notificationText: timeText,
      callback: _foregroundEntryPoint,
    );
  }

  static void update(String timeText) {
    if (!_supported) return;
    FlutterForegroundTask.updateService(notificationText: timeText);
  }

  static void stop() {
    if (!_supported) return;
    FlutterForegroundTask.stopService();
  }
}
