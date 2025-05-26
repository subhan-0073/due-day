import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/ui/screens/add_task_screen.dart';
import 'package:dueday/src/ui/widgets/deadline_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> deadlines = [
    Task(title: "Task 1", dueDate: DateTime.now().add(Duration(days: 3))),
    Task(title: "Task 2", dueDate: DateTime.now()),
    Task(title: "Task 3", dueDate: DateTime.now().subtract(Duration(days: 2))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Due Day"), centerTitle: true),
      body: Center(
        child: ListView.builder(
          itemCount: deadlines.length,
          itemBuilder: (context, index) {
            return DeadlineTile(task: deadlines[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null && newTask is Task) {
            setState(() {
              deadlines.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
