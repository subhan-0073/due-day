import 'package:dueday/src/models/task.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _title;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(label: Text("Task Title")),
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
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text("Pick Due Date"),
            ),
            Text(
              _selectedDate == null
                  ? 'No date chosen'
                  : 'Selected date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please pick a due date')),
                    );
                    return;
                  }
                  _formKey.currentState!.save();
                  Navigator.pop(
                    context,
                    Task(title: _title!, dueDate: _selectedDate!),
                  );
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
