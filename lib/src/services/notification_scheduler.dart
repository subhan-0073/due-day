import 'package:dueday/src/services/notification_service.dart';
import 'package:dueday/src/services/notification_settings_service.dart';
import 'package:dueday/src/utils/android_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  static Future<void> scheduleDailyMidnightNotification(
    List<String> dueTaskTitles,
  ) async {
    final settings = NotificationSettingsService.getSettings();

    if (settings == null || !settings.isEnabled) {
      return;
    } else {
      await NotificationService.requestNotificationPermission();
      if (!await AndroidUtils.canScheduleExactAlarms()) {
        await AndroidUtils.openExactAlarmSettingsIfRequired();
      }
    }

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.hour,
      settings.minute,
    );

    // scheduleDate = now.add(Duration(seconds: 1));

    if (scheduleDate.isBefore((now))) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    String notificationBody;

    if (dueTaskTitles.isEmpty) {
      notificationBody = "No tasks due today. Enjoy your day";
    } else if (dueTaskTitles.length == 1) {
      notificationBody = "You have 1 task due today: ${dueTaskTitles.first}";
    } else {
      notificationBody =
          "You have ${dueTaskTitles.length} tasks due today. Don't forget to check them!";
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'due_day_channel',
          'Due Day Notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );
    const dailyNotificationId = 1001;
    await NotificationService.notificationsPlugin.zonedSchedule(
      dailyNotificationId,
      'Task Due Today',
      notificationBody,
      scheduleDate,
      platformDetails,

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // static Future<void> showTestNotification() async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //         'due_day_channel',
  //         'Due Day Notifications',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       );

  //   const NotificationDetails platformDetails = NotificationDetails(
  //     android: androidDetails,
  //   );

  //   await NotificationService.notificationsPlugin.show(
  //     0,
  //     'Test Reminder',
  //     'THis is test notificationDetails',
  //     platformDetails,
  //   );
  // }
}
