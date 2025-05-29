import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'todo_list.dart';
import 'todo_list_detail_page.dart';
import 'todo_item.dart'; // Gerekebilir
import 'settings_page.dart';

class TodoListsPage extends StatefulWidget {
  const TodoListsPage({super.key});

  @override
  State<TodoListsPage> createState() => _TodoListsPageState();
}

class _TodoListsPageState extends State<TodoListsPage> {
  final TextEditingController _controller = TextEditingController();
  late Box<TodoList> _listBox;
  late Box<TodoItem> _itemBox;

  @override
  void initState() {
    super.initState();
    _listBox = Hive.box<TodoList>('todo_lists');
    _itemBox = Hive.box<TodoItem>('todo_items');
  }

  void _createNewList(String title) async {
    if (title.trim().isEmpty) return;

    final newList = TodoList(title: title.trim(), items: HiveList(_itemBox));
    await _listBox.add(newList);
    _controller.clear();
    setState(() {});
  }

  void _deleteList(int index) async {
    // İstersen burada list.items içindeki tüm TodoItem'ları da silebilirsin.
    await _listBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listelerim'),
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
                      labelText: 'Yeni liste adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _createNewList(_controller.text),
                  child: const Text('Oluştur'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _listBox.listenable(),
              builder: (context, Box<TodoList> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('Henüz liste yok.'));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final list = box.getAt(index);
                    if (list == null) return const SizedBox();

                    return ListTile(
                      title: Text(list.title),
                      subtitle: Text('${list.items?.length ?? 0} görev'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TodoListDetailPage(listKey: index),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteList(index),
                      ),
                    );
                  },
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
}
