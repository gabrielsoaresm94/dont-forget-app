import 'package:dont_forget_app/components/send_buttons.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      'Ligar para o fornecedor',
      'Enviar relatório mensal',
      'Comprar tinta branca',
      'Organizar arquivos de 2024',
    ];

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
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderColor),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Text(tasks[index], style: AppTheme.bodyText),
                    ),
                  ),
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
