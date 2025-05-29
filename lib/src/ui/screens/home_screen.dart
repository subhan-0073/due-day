import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/ui/screens/add_task_screen.dart';
import 'package:dueday/src/ui/widgets/deadline_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<Task>? box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    box = await Hive.openBox('tasksBox');
    setState(() {});
  }

  Future<void> _editTask(task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return AddTaskScreen(task: task);
        },
      ),
    );

    if (updatedTask != null && updatedTask is Task) {
      final key = task.key;
      await box?.put(key, updatedTask);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task updated"), duration: Duration(seconds: 3)),
      );
    }
  }

  void _markAsDone(Task task) {
    task.isDone = !task.isDone;
    task.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task marked as ${task.isDone ? "done" : "not done"}"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _deleteTask(Task task) {
    final key = task.key;
    task.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task removed successfully"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              box?.put(key, task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (box == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Due Day"), centerTitle: true),

      body: ValueListenableBuilder(
        valueListenable: box!.listenable(),
        builder: (context, Box<Task> box, _) {
          final deadlines = box.values.toList();

          deadlines.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          if (deadlines.isEmpty) {
            return Center(child: Text("No tasks yet"));
          }

          return Center(
            child: ListView.builder(
              itemCount: deadlines.length,
              itemBuilder: (context, index) {
                final task = deadlines[index];

                return Dismissible(
                  key: Key(task.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _editTask(task); //swipe right
                      return false;
                    } else {
                      _markAsDone(task); //swipe left
                      return false;
                    }
                  },
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text("Select option"),
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _editTask(task);
                                },
                                child: Text('Edit task'),
                              ),
                              SimpleDialogOption(
                                child: task.isDone
                                    ? Text("Mark as not done")
                                    : Text("Mark as done"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _markAsDone(task);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Delete Task"),
                                onPressed: () {
                                  Navigator.pop(context);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text(
                                          "Are you sure you want to delete this task?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deleteTask(task);
                                            },
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: DeadlineTile(task: task),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          if (newTask != null && newTask is Task) {
            box?.add(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
