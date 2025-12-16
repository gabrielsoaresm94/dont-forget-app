import 'dart:math';
import 'package:dont_forget_app/models/task_model.dart';
import 'package:dont_forget_app/services/task_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((
  ref,
) {
  return TaskNotifier(ref.read(taskServiceProvider));
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskService service;

  TaskNotifier(this.service) : super([]) {
    // carrega automaticamente ao criar o notifier
    Future.microtask(loadAll);
  }

  Future<void> loadAll() async {
    final tasks = await service.getTasks();
    state = tasks;
  }

  Future<void> loadAllWithRetry({
    int attempts = 8,
    Duration initialDelay = const Duration(milliseconds: 200),
  }) async {
    var delay = initialDelay;

    for (var i = 0; i < attempts; i++) {
      try {
        final tasks = await service.getTasks();
        state = tasks;
        return;
      } catch (_) {
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: min((delay.inMilliseconds * 1.35).round(), 2000),
        );
      }
    }
  }

  Future<void> loadTask(int id) async {
    final task = await service.getTask(id);
    state = [
      for (final t in state)
        if (t.id == id) task else t,
      if (!state.any((t) => t.id == id)) task,
    ];
  }

  Future<void> addTask({
    required String description,
    required int categoryId,
    required DateTime date,
  }) async {
    // snapshot antes (pra consistência eventual)
    final before = state;
    final beforeMaxId = before.isEmpty
        ? 0
        : before.map((t) => t.id).reduce(max);

    final newTask = TaskModel(
      id: 0,
      description: description,
      expiredAt: date,
      categoryId: categoryId,
    );

    // comando (sem retorno)
    await service.createTask(newTask);

    // espera o read-model refletir
    await _waitForNewTask(beforeMaxId: beforeMaxId);
  }

  Future<void> updateTask(TaskModel updated) async {
    await service.updateTask(updated);
    await loadAllWithRetry();
  }

  Future<void> deleteTask(int id) async {
    await service.deleteTask(id);
    // otimismo local + correção eventual
    state = state.where((t) => t.id != id).toList();
    await loadAllWithRetry();
  }

  Future<void> _waitForNewTask({required int beforeMaxId}) async {
    var delay = const Duration(milliseconds: 200);

    for (var i = 0; i < 12; i++) {
      await Future.delayed(delay);

      final list = await service.getTasks();
      state = list;

      final hasNew = list.any((t) => t.id > beforeMaxId);
      if (hasNew) return;

      delay = Duration(
        milliseconds: min((delay.inMilliseconds * 1.35).round(), 2000),
      );
    }
  }
}
