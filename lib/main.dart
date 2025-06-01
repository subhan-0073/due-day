import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/ui/screens/home_screen.dart';
import 'package:dueday/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasksBox');
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
