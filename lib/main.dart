import 'package:dueday/src/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DueDay());
}

class DueDay extends StatelessWidget {
  const DueDay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: false),
      debugShowCheckedModeBanner: false,
    );
  }
}
