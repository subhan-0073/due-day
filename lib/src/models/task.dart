import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final String? category;
  bool isDone;
  Task({
    String? id,
    required this.title,
    required this.dueDate,
    this.category,
    this.isDone = false,
  }) : id = id ?? Uuid().v4();
}
