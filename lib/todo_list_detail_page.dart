import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'todo_list.dart';
import 'todo_item.dart';
import 'intent_url_launcher.dart';

class TodoListDetailPage extends StatefulWidget {
  final int listKey;

  const TodoListDetailPage({super.key, required this.listKey});

  @override
  State<TodoListDetailPage> createState() => _TodoListDetailPageState();
}

class _TodoListDetailPageState extends State<TodoListDetailPage> {
  final TextEditingController _controller = TextEditingController();
  late TodoList list;
  late Box<TodoList> _listBox;
  late Box<TodoItem> _itemBox;

  @override
  void initState() {
    super.initState();
    _listBox = Hive.box<TodoList>('todo_lists');
    _itemBox = Hive.box<TodoItem>('todo_items');
    list = _listBox.getAt(widget.listKey)!;
  }

  void _addItem(String task) async {
    if (task.trim().isEmpty) return;

    final newItem = TodoItem(task: task.trim());
    await _itemBox.add(newItem);

    if (list.items == null) {
      list.items = HiveList(_itemBox);
    }

    list.items!.add(newItem);
    await list.save();

    setState(() {
      _controller.clear();
    });
  }

  void _toggleDone(int index) async {
    final item = list.items![index];
    item.isDone = !item.isDone;
    await item.save(); // Tek item'i de güncelle

    setState(() {});
  }

  void _removeItem(int index) async {
    final item = list.items!.removeAt(index);
    await item.delete(); // Silme işlemi hem listeden hem de item kutusundan olmalı
    await list.save();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(list.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Yeni görev',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _addItem(_controller.text),
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = list.items![index];
                return ListTile(
                  title: intentUrlLauncher(item.task, item.isDone),
                  leading: Checkbox(
                    value: item.isDone,
                    onChanged: (_) => _toggleDone(index),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
