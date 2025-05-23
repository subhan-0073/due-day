import 'package:dueday/src/models/task.dart';
import 'package:flutter/material.dart';

class DeadlineTile extends StatelessWidget {
  final Task task;
  const DeadlineTile({required this.task, super.key});

  String getCountdownText() {
    final now = DateTime.now();
    final difference = task.dueDate.difference(now).inDays;

    if (difference > 0) {
      return 'Due in $difference day${difference > 1 ? 's' : ''}';
    } else if (difference == 0) {
      return 'Due today';
    } else {
      return 'Overdue by ${difference.abs()} day${difference.abs() > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(getCountdownText()),
      trailing: Text(
        '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
      ),
    );
  }
}
