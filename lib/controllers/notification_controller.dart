import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future notificationSelected(String? payload) {
    return Future.value();
  }

  Future showDailyNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "id",
      "Name",
      "Description",
      importance: Importance.high,
    );

    const generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      "Did you check your status today?",
      "Let's save your favourites 😍",
      RepeatInterval.daily,
      generalNotificationDetails,
    );
  }

  Future showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "id",
      "Name",
      "Description",
      importance: Importance.high,
    );

    const generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      "Hey..! Welcome 👋",
      "Enjoy with your status saver 🤩",
      generalNotificationDetails,
    );
  }

  void cancel() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void initialize() {
    const androidInitialize =
        AndroidInitializationSettings('noti');
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: notificationSelected,
    );
  }
}
