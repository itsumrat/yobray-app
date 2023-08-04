import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    // IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<NotificationDetails> notification(
      {required String title,
      required String body,
      dynamic scheduledDate,
      required int id}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );

    return NotificationDetails(
        android: androidNotificationDetails);
  }

  static Future<NotificationDetails> showNotification(
      {required String title, required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _notificationsPlugin.show(-1, title, body, notificationDetails);
    return NotificationDetails(
        android: androidNotificationDetails);
  }

  static void stopNotification(id) async {
    _notificationsPlugin.cancel(id);
  }

  static onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("is $id");
  }
}
