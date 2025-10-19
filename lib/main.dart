import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/tasks.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routes: {
        '/': (context) => const HomeScreen(),
        '/tasks': (context) => const TasksScreen(),
      },
      initialRoute: '/',
    );
  }
}
