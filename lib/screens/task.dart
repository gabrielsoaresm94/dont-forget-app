import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/task_input.dart';
import '../components/category_dropdown.dart';
import '../components/date_time_picker.dart';
import '../components/send_buttons.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _controller;
  late int _categoryId;
  DateTime? _date;
  TimeOfDay? _time;

  late TaskModel task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // recebe a task enviada pela rota
    task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    // solicita nova versão ao servidor
    ref.read(taskProvider.notifier).loadTask(task.id);

    // pega versão atualizada (ou a original)
    final updated = ref
        .read(taskProvider)
        .firstWhere((t) => t.id == task.id, orElse: () => task);

    _controller = TextEditingController(text: updated.description);
    _categoryId = updated.categoryId;

    _date = updated.expiredAt;
    _time = TimeOfDay(
      hour: updated.expiredAt.hour,
      minute: updated.expiredAt.minute,
    );
  }

  /// Atualiza task
  void _updateTask() async {
    if (_date == null || _time == null) return;

    final updatedExpiredAt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );

    final updatedTask = task.copyWith(
      description: _controller.text.trim(),
      expiredAt: updatedExpiredAt,
      categoryId: _categoryId,
    );

    await ref.read(taskProvider.notifier).updateTask(updatedTask);
    Navigator.pushNamed(context, '/tasks');
  }

  /// Remove task
  void _deleteTask() async {
    await ref.read(taskProvider.notifier).deleteTask(task.id);
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskInput(controller: _controller),
              const SizedBox(height: 20),

              /// 🔥 Novo dropdown corrigido
              CategoryAutocompleteDropdown(
                selectedCategoryId: _categoryId,
                onChanged: (value) {
                  setState(() => _categoryId = value!);
                },
              ),

              /// DateTimePicker
              DateTimePicker(
                selectedDate: _date,
                selectedTime: _time,
                onDateSelected: (date) => setState(() => _date = date),
                onTimeSelected: (time) => setState(() => _time = time),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFDEDEDE),
                      size: 32,
                    ),
                    onPressed: _updateTask,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFDEDEDE),
                      size: 32,
                    ),
                    onPressed: _deleteTask,
                  ),
                ],
              ),

              const Spacer(),

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
