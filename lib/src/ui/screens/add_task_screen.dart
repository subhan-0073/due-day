import 'package:dueday/src/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dueday/src/utils/padding.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({this.task, super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _title;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.horizontal,
          vertical: AppPadding.vertical,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(labelText: "Task Title"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!.trim();
                },
              ),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : 'Due: ${DateFormat.yMMMMd().format(_selectedDate!)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _selectedDate != null
                        ? Colors.tealAccent.withAlpha(179)
                        : Colors.redAccent.withAlpha(204),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    // firstDate: DateTime(2000),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text("Pick Due Date"),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please pick a due date'),
                          ),
                        );
                        return;
                      }
                      _formKey.currentState!.save();
                      Navigator.pop(
                        context,
                        Task(
                          title: _title!,
                          dueDate: _selectedDate!,
                          id: widget.task?.id,
                        ),
                      );
                    }
                  },
                  child: widget.task == null
                      ? const Text("Add Task")
                      : const Text("Save Changes"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
