import 'package:hive/hive.dart';
import 'todo_item.dart';

part 'todo_list.g.dart'; // Hive için gerekli

@HiveType(typeId: 1)
class TodoList extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  HiveList<TodoItem>? items;  // Burada HiveList kullanıyoruz.

  TodoList({required this.title, this.items});
}
