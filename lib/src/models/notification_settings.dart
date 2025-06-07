import 'package:hive/hive.dart';

part 'notification_settings.g.dart';

@HiveType(typeId: 1)
class NotificationSettings extends HiveObject {
  @HiveField(0)
  final bool isEnabled;
  @HiveField(1)
  final int hour;
  @HiveField(2)
  final int minute;
  NotificationSettings({
    required this.isEnabled,
    required this.hour,
    required this.minute,
  });
}
