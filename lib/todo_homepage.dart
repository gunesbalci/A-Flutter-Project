/*import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'settings_page.dart';
import 'intent_url_launcher.dart';
import 'notification_service.dart';

part 'todo_homepage.g.dart';  // hive için gerekli

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

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<TodoItem> _items = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromHive();  // Başlangıçta Hive'dan yükle
  }

  // Hive'a kaydet (Hive otomatik kaydeder, burada sadece bilgi veriyoruz)
  Future<void> _saveToHive() async {
    final box = Hive.box<TodoItem>('todos');
    await box.clear();
    for (var item in _items) {
      await box.add(item);
    }
  }

  // Hive'dan yükle
  Future<void> _loadFromHive() async {
    final box = Hive.box<TodoItem>('todos');
    setState(() {
      _items = box.values.toList();
    });
  }

  void _addItem(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      _items.add(TodoItem(task: task));
      _controller.clear();
    });
    _saveToHive();
  }

  void _toggleDone(int index) {
    setState(() {
      _items[index].isDone = !_items[index].isDone;
    });
    _saveToHive();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _saveToHive();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('To-Do List'),
      ),

      body: Column
      (
        children: 
        [
          Padding
          (
            padding: const EdgeInsets.all(8.0),
            child: Row
            (
              children: 
              [
                Expanded
                (
                  child: TextField
                  (
                    controller: _controller,
                    decoration: const InputDecoration
                    (
                      labelText: 'Yeni görev',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton
                (
                  onPressed: () => _addItem(_controller.text),
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder
            (
              itemCount: _items.length,
              itemBuilder: (context, index) 
              {
                final item = _items[index];
                return ListTile
                (
                  title: intentUrlLauncher(item.task, item.isDone),
                  leading: Checkbox
                  (
                    value: item.isDone,
                    onChanged: (_) => _toggleDone(index),
                  ),
                  trailing: IconButton
                  (
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            child: const Text('Ayarlar'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    NotificationService().dispose(); 
    super.dispose();
  }
}
*/