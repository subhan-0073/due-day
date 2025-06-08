import 'package:dueday/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dueday/src/utils/padding.dart';

class DeadlineTile extends StatelessWidget {
  final Task task;
  const DeadlineTile({required this.task, super.key});

  String getCountdownText() {
    final now = DateTime.now();
    Duration difference = task.dueDate.difference(now);
    int totalDays = difference.inDays;
    final absDays = totalDays.abs();
    if (totalDays == 0) return 'Due Today';
    int years = absDays ~/ 365;
    int months = (absDays % 365) ~/ 30;
    int weeks = ((absDays % 365) % 30) ~/ 7;

    int days = ((absDays % 365) % 30) % 7;

    List<String> parts = [];
    if (years > 0) parts.add('$years year${years > 1 ? 's' : ''}');
    if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
    if (weeks > 0) parts.add('$weeks week${weeks > 1 ? 's' : ''}');
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');

    final timeString = parts.join(', ');
    return totalDays > 0 ? 'Due in $timeString' : 'Overdue by $timeString';
  }

  Color getTileBackgroundColor() {
    if (task.isDone) return Colors.grey.shade800.withAlpha(40);

    final now = DateTime.now();
    final diffDays = task.dueDate.difference(now).inDays;
    if (diffDays < 0) {
      return Colors.red.shade900.withAlpha(38);
    } else if (diffDays == 0) {
      return Colors.orange.shade800.withAlpha(38);
    } else if (diffDays <= 3) {
      return Colors.yellow.shade700.withAlpha(31);
    } else {
      return Colors.green.shade700.withAlpha(20);
    }
  }

  Color getCountdownColor() {
    final now = DateTime.now();
    final difference = task.dueDate.difference(now).inDays;

    if (difference == 0) {
      return Colors.orange.shade300;
    }
    if (difference > 0) {
      return Colors.green.shade300;
    }
    return Colors.red.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMMM y').format(task.dueDate);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.horizontal,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: getTileBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(AppPadding.all),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: task.isDone
                        ? Colors.tealAccent.shade700.withAlpha(77)
                        : Colors.blueGrey.shade700.withAlpha(102),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: task.isDone
                            ? Colors.tealAccent.shade100
                            : Colors.white70,
                      ),

                      const SizedBox(width: 6),
                      Text(
                        task.isDone ? 'Completed' : formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: task.isDone
                              ? Colors.tealAccent.shade100
                              : Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontStyle: task.isDone
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            task.isDone
                ? const SizedBox.shrink()
                : Text(
                    getCountdownText(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: getCountdownColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
