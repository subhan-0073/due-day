import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/ui/widgets/deadline_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Task> tasks = [
    Task(title: "Task 1", dueDate: DateTime.now().subtract(Duration(days: 2))),
    Task(title: "Task 2", dueDate: DateTime.now()),
    Task(title: "Task 3", dueDate: DateTime.now().add(Duration(days: 2))),
    Task(title: "Task 4", dueDate: DateTime.now().add(Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Due Day"), centerTitle: true),
      body: Center(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return DeadlineTile(task: tasks[index]);
          },
        ),
      ),
    );
  }
}
