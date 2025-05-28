import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'theme_provider.dart';
import 'todo_homepage.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestNotificationPermission();

  await NotificationService().init();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoItemAdapter());
  await Hive.openBox<TodoItem>('todos');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Tema Ayarı',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(colorScheme: myLightScheme),
      darkTheme: ThemeData.dark().copyWith(colorScheme: myDarkScheme),
      home: const TodoHomePage(),
    );
  }
}

final myLightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.deepPurple,
  onPrimary: Colors.white,
  secondary: Colors.deepPurple.shade200,
  onSecondary: Colors.black,
  error: Colors.red.shade700,
  onError: Colors.white,
  surface: Colors.deepPurple.shade200,
  onSurface: Colors.black,
);

final myDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.deepPurple.shade200,
  onPrimary: Colors.black,
  secondary: Colors.deepPurple.shade900,
  onSecondary: Colors.black,
  error: Colors.red.shade400,
  onError: Colors.black,
  surface: Colors.deepPurple.shade900,
  onSurface: Colors.white,
);

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}