import 'package:dueday/src/models/task.dart';
import 'package:dueday/src/models/task_filter_sort.dart';
import 'package:dueday/src/services/notification_scheduler.dart';
import 'package:dueday/src/services/notification_settings_service.dart';
import 'package:dueday/src/ui/screens/add_task_screen.dart';
import 'package:dueday/src/ui/widgets/deadline_tile.dart';
import 'package:dueday/src/ui/widgets/notification_setup_dialog.dart';
import 'package:dueday/src/ui/widgets/sort_chip.dart';
import 'package:dueday/src/ui/widgets/task_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<Task>? box;
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.dueDateAsc;
  late final Future<void> Function() _boxlistener;
  @override
  void initState() {
    super.initState();
    _openBox();
    _boxlistener = () async {
      await _scheduledNotificationsForToday();
    };

    if (NotificationSettingsService.isNotificationEnabled() == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => const NotificationSetupDialog(),
        );
      });
    }
  }

  @override
  void dispose() {
    box?.listenable().removeListener(_boxlistener);
    super.dispose();
  }

  Future<void> _scheduledNotificationsForToday() async {
    final now = DateTime.now();
    final dueTodayTitles =
        box?.values
            .where(
              (task) =>
                  !task.isDone &&
                  task.dueDate.year == now.year &&
                  task.dueDate.month == now.month &&
                  task.dueDate.day == now.day,
            )
            .map((task) => task.title)
            .toList() ??
        [];

    await NotificationScheduler.scheduleDailyMidnightNotification(
      dueTodayTitles,
    );
  }

  Future<void> _openBox() async {
    box = Hive.box('tasksBox');

    await _scheduledNotificationsForToday();

    box!.listenable().addListener(() {
      _boxlistener();
    });
    setState(() {});
  }

  Future<void> _editTask(Task task) async {
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
        const SnackBar(
          content: Text("Task updated"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _markAsDone(Task task) {
    setState(() {
      task.isDone = !task.isDone;
      task.save();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task marked as ${task.isDone ? "done" : "not done"}"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _deleteTask(Task task) {
    final key = task.key;
    task.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task removed successfully"),
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

  List<Task> _filterTasks(List<Task> tasks) {
    switch (_currentFilter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isDone).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isDone).toList();
      case TaskFilter.all:
        return tasks;
    }
  }

  List<Task> _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;

      switch (_currentSort) {
        case TaskSort.dueDateAsc:
          return a.dueDate.compareTo(b.dueDate);
        case TaskSort.dueDateDesc:
          return b.dueDate.compareTo(a.dueDate);
        case TaskSort.titleAsc:
          return a.title.compareTo(b.title);
        case TaskSort.titleDesc:
          return b.title.compareTo(a.title);
      }
    });

    return tasks;
  }

  String _getEmptyMessage(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.active:
        return "No active tasks right now";
      case TaskFilter.completed:
        return "No completed tasks yet";
      case TaskFilter.all:
        return "No tasks yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (box == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.tealAccent.withAlpha(77),
                      width: 0.6,
                    ),
                  ),

                  child: const Text(
                    "Made with 💙 by @subhan_0073",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: const Text("Due Day"),
        ),
        centerTitle: true,
      ),

      body: ValueListenableBuilder(
        valueListenable: box!.listenable(),
        builder: (context, Box<Task> box, _) {
          final deadlines = box.values.toList();
          final filteredTasks = _filterTasks(deadlines);
          final sortedTasks = _sortTasks(filteredTasks);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4),
                    SortChip(
                      currentSort: _currentSort,
                      onSortChanged: (newSort) {
                        setState(() {
                          _currentSort = newSort;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    TaskFilterChips(
                      currentFilter: _currentFilter,
                      onFilterChanged: (newFilter) {
                        setState(() {
                          _currentFilter = newFilter;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: sortedTasks.isEmpty
                    ? Center(child: Text(_getEmptyMessage(_currentFilter)))
                    : ListView.builder(
                        itemCount: sortedTasks.length,
                        itemBuilder: (context, index) {
                          final task = sortedTasks[index];

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
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    task.isDone ? "Undo" : "Done",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    task.isDone ? Icons.undo : Icons.check,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      backgroundColor: const Color(0xFF1E1E1E),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),

                                      title: const Text(
                                        "Task options",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      children: [
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _editTask(task);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.tealAccent,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Edit task',
                                                style: TextStyle(
                                                  color: Colors.tealAccent,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: Row(
                                            children: [
                                              Icon(
                                                task.isDone
                                                    ? Icons.undo
                                                    : Icons.check,
                                                color: Colors.tealAccent,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                task.isDone
                                                    ? "Mark as not done"
                                                    : "Mark as done",
                                                style: const TextStyle(
                                                  color: Colors.tealAccent,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _markAsDone(task);
                                          },
                                        ),
                                        SimpleDialogOption(
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Delete Task',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: const Color(
                                                  0xFF292929,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),

                                                title: const Text(
                                                  "Confirm Deletion",
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to delete this task?",
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.tealAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _deleteTask(task);
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (newTask != null && newTask is Task) {
            box?.add(newTask);
          }
        },
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
