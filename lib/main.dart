import 'package:dueday/src/models/notification_settings.dart';
import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/services/notification_service.dart';
import 'package:dueday/src/ui/screens/home_screen.dart';
import 'package:dueday/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NotificationSettingsAdapter());
  await Hive.openBox<NotificationSettings>('notificationSettingsBox');

  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');

  await NotificationService.init();

  runApp(const DueDay());
}

class DueDay extends StatelessWidget {
  const DueDay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
