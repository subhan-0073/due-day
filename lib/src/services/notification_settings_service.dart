import 'package:dueday/src/models/notification_settings.dart';
import 'package:hive/hive.dart';

class NotificationSettingsService {
  static final _notificationSettingsBox = Hive.box<NotificationSettings>(
    'notificationSettingsBox',
  );

  static NotificationSettings? getSettings() {
    return _notificationSettingsBox.get('settings');
  }

  static Future<void> saveSettings(NotificationSettings settings) async {
    await _notificationSettingsBox.put('settings', settings);
  }

  static Future<void> clearSettings() async {
    await _notificationSettingsBox.delete('settings');
  }

  static bool? isNotificationEnabled() {
    return getSettings()?.isEnabled;
  }
}
