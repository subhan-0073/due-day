import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) await Permission.notification.request();
  }

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();

    try {
      tz.setLocalLocation(tz.getLocation(localTimeZone));
    } catch (e) {
      // print(tz.local.toString());
      // print(e.toString());
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'due_day_channel',
      'Due Day Notifications',
      importance: Importance.high,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
