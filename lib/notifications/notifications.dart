import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicinereminder/notifications/notification_permission.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  Future showNotification(
    String title,
    String body,
    int time,
    int id,
  ) async {
    const AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannel =
        NotificationDetails(android: androidChannel);

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannel,
      payload: 'The payload is the medicine ID: $id',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
