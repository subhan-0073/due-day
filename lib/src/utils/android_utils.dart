import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dueday/src/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AndroidUtils {
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid &&
        (await NotificationService.notificationsPlugin
                    .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin
                    >()
                    ?.canScheduleExactNotifications() ??
                true) ==
            false) {
      return false;
    }
    return true;
  }

  static Future<void> openExactAlarmSettingsIfRequired() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 31) {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );

        await intent.launch();
      }
    }
  }
}
