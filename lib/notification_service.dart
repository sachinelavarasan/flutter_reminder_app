// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);

    // const AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails(
    //   'reminder',
    //   'Reminder Notification',
    //   channelDescription: 'Notification sent as reminder',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   enableVibration: true,
    // );

    // const NotificationDetails notificationDetails =
    //     NotificationDetails(android: androidNotificationDetails);
  }

  getAndroidNotificationDetails() {
    return const AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      channelDescription: 'Notification sent as reminder',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );
  }

  getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
    );
  }

  Future<bool> reminderHasNotification(String id) async {
    var pendingNotifications =
        await _localNotifications.pendingNotificationRequests();
    // ignore: unrelated_type_equality_checks
    return pendingNotifications.any((notification) => notification.id == id);
  }

  void updateNotification({id, title, body, time}) async {
    var hasNotification = await reminderHasNotification(id);
    if (hasNotification) {
      _localNotifications.cancel(id);
    }
  }

  void cancelNotification(int id) {
    _localNotifications.cancel(id);
    print('$id canceled');
  }

  Future<dynamic> scheduleNotifications(
      dynamic id, dynamic title, dynamic body, dynamic time) async {
    await _localNotifications.zonedSchedule(
      id,
      'title',
      'body',
      notificationTime(time!),
      getNotificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showScheduledLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    final platformChannelSpecifics = await getNotificationDetails();
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  tz.TZDateTime notificationTime(DateTime dateTime) {
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}
