import 'package:dont_forget_app/screens/task.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/tasks.dart';
import 'utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dont Forget',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/tasks': (_) => const TasksScreen(),
        '/task': (_) => const TaskDetailScreen(),
      },
    );
  }
}
