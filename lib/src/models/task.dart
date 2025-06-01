import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime dueDate;
  @HiveField(3)
  final String? category;

  @HiveField(4)
  bool isDone;
  Task({
    String? id,
    required this.title,
    required this.dueDate,
    this.category,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4();
}
