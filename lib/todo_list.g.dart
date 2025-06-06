// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoListAdapter extends TypeAdapter<TodoList> {
  @override
  final int typeId = 1;

  @override
  TodoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoList(
      title: fields[0] as String,
      items: (fields[1] as HiveList?)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
