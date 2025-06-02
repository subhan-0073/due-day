import 'package:dueday/src/models/task_filter_sort.dart';
import 'package:flutter/material.dart';

class SortChip extends StatefulWidget {
  final TaskSort currentSort;
  final ValueChanged<TaskSort> onSortChanged;
  const SortChip({
    required this.currentSort,
    required this.onSortChanged,
    super.key,
  });

  @override
  State<SortChip> createState() => _SortChipState();
}

class _SortChipState extends State<SortChip> {
  String _getSortLabel(TaskSort sort) {
    switch (sort) {
      case TaskSort.dueDateAsc:
        return 'Due Date';
      case TaskSort.dueDateDesc:
        return 'Due Date';
      case TaskSort.titleAsc:
        return 'Title A-Z';
      case TaskSort.titleDesc:
        return 'Title Z-A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.vertical(
              top: Radius.circular(20),
            ),
          ),
          backgroundColor: const Color(0xFF121212),
          builder: (context) {
            TaskSort tempSort = widget.currentSort;
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: TaskSort.values.map((sort) {
                        return RadioListTile(
                          value: sort,
                          groupValue: tempSort,
                          onChanged: (TaskSort? newSort) {
                            if (newSort != null) {
                              setModalState(() => tempSort = newSort);
                              Navigator.pop(context);
                              widget.onSortChanged(newSort);
                            }
                          },
                          title: Text(
                            _getSortLabel(sort),
                            style: const TextStyle(color: Colors.white),
                          ),
                          activeColor: Colors.tealAccent,
                          contentPadding: EdgeInsets.zero,
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
              "Sort by",
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
