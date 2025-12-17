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
  late final TextEditingController _controller;

  ProviderSubscription<List<TaskModel>>? _taskSub;

  bool _initialized = false;
  bool _syncedFromProvider = false;

  int? _categoryId;
  DateTime? _date;
  TimeOfDay? _time;

  late TaskModel task;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _taskSub = ref.listenManual<List<TaskModel>>(taskProvider, (prev, next) {
      if (!_initialized) return;

      final exists = next.any((t) => t.id == task.id);
      if (!exists) return;

      final t = next.firstWhere((x) => x.id == task.id);

      if (_syncedFromProvider) return;
      _syncedFromProvider = true;

      if (!mounted) return;
      setState(() {
        _controller.text = t.description;
        _categoryId = t.categoryId;
        _date = t.expiredAt;
        _time = TimeOfDay(hour: t.expiredAt.hour, minute: t.expiredAt.minute);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    _controller.text = task.description;
    _categoryId = task.categoryId;
    _date = task.expiredAt;
    _time = TimeOfDay(hour: task.expiredAt.hour, minute: task.expiredAt.minute);

    Future.microtask(() => ref.read(taskProvider.notifier).loadTask(task.id));
  }

  @override
  void dispose() {
    _taskSub?.close();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    if (_date == null || _time == null || _categoryId == null) return;

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
      categoryId: _categoryId!,
    );

    await ref.read(taskProvider.notifier).updateTask(updatedTask);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/tasks');
  }

  Future<void> _deleteTask() async {
    await ref.read(taskProvider.notifier).deleteTask(task.id);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF131313),
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

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

              CategoryAutocompleteDropdown(
                selectedCategoryId: _categoryId,
                onChanged: (value) => setState(() => _categoryId = value),
                onCategoryDeleted: () =>
                    // Navigator.of(context).popUntil((route) => route.isFirst),
                    Navigator.pushReplacementNamed(context, '/'),
              ),

              DateTimePicker(
                selectedDate: _date,
                selectedTime: _time,
                onDateSelected: (date) => setState(() => _date = date),
                onTimeSelected: (time) => setState(() => _time = time),
              ),

              Row(
                children: [
                  _iconButton(Icons.north_west_rounded, _updateTask),
                  _iconButton(Icons.delete_outline, _deleteTask),
                ],
              ),

              SendButtons(
                onHome: () => Navigator.pushReplacementNamed(context, '/'),
                onList: () => Navigator.pushReplacementNamed(context, '/tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDEDEDE)),
        ),
        child: Icon(icon, size: 28, color: const Color(0xFFDEDEDE)),
      ),
    );
  }
}
