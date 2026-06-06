import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../language/language_controller.dart';
import '../../utils/strings.dart';

class NotificationService {
  /// set channel info
  static const String channelId = '1';
  static String channelName = Strings.appName;

  /// Initialize Local Notification
  static void init() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        // Android settings.
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        // iOS settings.
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static NotificationDetails notificationDetails = NotificationDetails(
    // Android details.
    android: AndroidNotificationDetails(channelId, channelName),
    // iOS details.
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static void showLocalNotificationPusher({
    required String title,
    required String body,
  }) {
    flutterLocalNotificationsPlugin.show(
      id: const Uuid()
          .v4()
          .hashCode, // Use the unique ID as the notification ID
      title: title,
      body: Get.find<LanguageController>().getTranslation(body),
      notificationDetails: notificationDetails,
    );
    debugPrint("<<< Success! >>>");
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
