import 'package:dont_forget_app/components/send_buttons.dart';
import 'package:dont_forget_app/models/task_model.dart';
import 'package:dont_forget_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_theme.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Text('TASKS', style: AppTheme.headingMedium)]),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/task',
                            arguments: task,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.description,
                                  style: AppTheme.bodyText,
                                ),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (_) async {
                                  await ref
                                      .read(taskProvider.notifier)
                                      .deleteTask(task.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SendButtons(
                onHome: () => Navigator.pushNamed(context, '/'),
                onList: () => Navigator.pushNamed(context, '/tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
