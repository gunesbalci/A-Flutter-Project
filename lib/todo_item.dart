import 'package:hive/hive.dart';

part 'todo_item.g.dart'; // Hive için gerekli

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isDone;

  TodoItem({required this.task, this.isDone = false});

  Map<String, dynamic> toJson() => {
        'task': task,
        'isDone': isDone,
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        task: json['task'],
        isDone: json['isDone'],
      );
}
