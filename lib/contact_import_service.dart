import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import 'todo_list.dart';
import 'todo_item.dart';

class ContactImportService {
  final Box<TodoItem> itemBox = Hive.box<TodoItem>('todo_items');
  final Box<TodoList> listBox = Hive.box<TodoList>('todo_lists');

  Future<void> importContactsAsTodoList() async {
    // İzin al
    print('alo0');
    await Permission.contacts.request();
    if (!await FlutterContacts.requestPermission()) return;
    if (!await FlutterContacts.requestPermission()) return;
    print('alo1');
    // Kişileri al (sadece telefonlar yeter)
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    print('alo2');
    // Yalnızca numaraları içeren TodoItem listesi
    final todoItems = <TodoItem>[];

    for (final contact in contacts) {
      for (final phone in contact.phones) {
        if (phone.number.trim().isNotEmpty) {
          final item = TodoItem(task: phone.number.trim());
          await itemBox.add(item);
          todoItems.add(item);
        }
      }
    }
    print('alo3');
    // Yeni TodoList oluştur ve HiveList ile ilişkilendir
    final hiveList = HiveList<TodoItem>(itemBox);
    hiveList.addAll(todoItems);

    final todoList = TodoList(title: 'Contacts', items: hiveList);
    print('Toplam kişi sayısı: ${contacts.length}');
    print('Toplam todoItem eklendi: ${todoItems.length}');
    print('HiveList boyutu: ${hiveList.length}');
    print('itemBox boyutu: ${itemBox.length}');
    await listBox.add(todoList);
    print('TodoList sayısı: ${listBox.length}');
  }
}
