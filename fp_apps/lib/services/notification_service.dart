import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    const AndroidInitializationSettings
        androidInitializationSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
        initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(
      initializationSettings,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {

    const AndroidNotificationDetails
        androidNotificationDetails =
        AndroidNotificationDetails(
      'study_channel',
      'Study Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails
        notificationDetails =
        NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}