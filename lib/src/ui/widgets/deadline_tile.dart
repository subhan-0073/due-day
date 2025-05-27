import 'package:dueday/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Color getCountdownColor() {
    final now = DateTime.now();
    final difference = task.dueDate.difference(now).inDays;

    if (difference == 0) {
      return Colors.orange;
    } else if (difference > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMMM y').format(task.dueDate);

    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: task.isDone ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        getCountdownText(),
        style: TextStyle(color: getCountdownColor()),
      ),
      trailing: Text(formattedDate),
    );
  }
}
