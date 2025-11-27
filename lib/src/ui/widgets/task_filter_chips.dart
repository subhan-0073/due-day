import 'package:dueday/src/models/task_filter_sort.dart';
import 'package:flutter/material.dart';

class TaskFilterChips extends StatefulWidget {
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const TaskFilterChips({
    required this.currentFilter,
    required this.onFilterChanged,
    super.key,
  });

  @override
  State<TaskFilterChips> createState() => _TaskFilterChipsState();
}

class _TaskFilterChipsState extends State<TaskFilterChips> {
  String _getFilterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.active:
        return 'Active';
      case TaskFilter.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF121212),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.vertical(
              top: Radius.circular(20),
            ),
          ),

          builder: (context) {
            TaskFilter tempFilter = widget.currentFilter;
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: TaskFilter.values.map((filter) {
                        return RadioGroup(
                          groupValue: tempFilter,
                          onChanged: (TaskFilter? newFilter) {
                            if (newFilter != null) {
                              setModalState(() => tempFilter = newFilter);
                              Navigator.pop(context);
                              widget.onFilterChanged(newFilter);
                            }
                          },
                          child: RadioListTile(
                            value: filter,
                            title: Text(
                              _getFilterLabel(filter),
                              style: const TextStyle(color: Colors.white),
                            ),
                            activeColor: Colors.tealAccent,
                            contentPadding: EdgeInsets.zero,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Chip(
        backgroundColor: const Color(0xFF121212),
        label: Row(
          children: [
            Text(
              "Filter",
              style: TextStyle(
                color: Colors.tealAccent.shade100,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
