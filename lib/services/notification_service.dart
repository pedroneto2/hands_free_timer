import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'timer_complete_channel';

  static Future<void> init() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showTimerComplete(int totalSeconds) async {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    final label = s == 0
        ? '$m min'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

    await _plugin.show(
      1,
      'Timer complete',
      '$label timer has finished',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Timer Complete',
          channelDescription: 'Notifies when the countdown finishes',
          importance: Importance.high,
          priority: Priority.high,
          playSound: false,
          enableVibration: false,
          autoCancel: true,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: false,
          presentBadge: false,
        ),
      ),
    );
  }
}
