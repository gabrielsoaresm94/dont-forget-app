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

  TaskNotifier(this.service)
    : super([
        TaskModel(
          id: 1,
          description: 'Ligar para o fornecedor',
          expiredAt: DateTime.now().add(const Duration(hours: 2)),
          categoryId: 1,
        ),
        TaskModel(
          id: 2,
          description: 'Enviar relatório mensal',
          expiredAt: DateTime.now().add(const Duration(days: 1)),
          categoryId: 1,
        ),
        TaskModel(
          id: 3,
          description: 'Comprar tinta branca',
          expiredAt: DateTime.now().add(const Duration(days: 2)),
          categoryId: 1,
        ),
        TaskModel(
          id: 4,
          description: 'Organizar arquivos de 2024',
          expiredAt: DateTime.now().add(const Duration(days: 3)),
          categoryId: 1,
        ),
      ]);

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
    final newTask = TaskModel(
      id: 0,
      description: description,
      expiredAt: date,
      categoryId: categoryId,
    );
    final createdTask = await service.createTask(newTask);
    state = [...state, createdTask];
  }

  Future<void> updateTask(TaskModel updated) async {
    final serverUpdated = await service.updateTask(updated);
    bool exists = state.any((t) => t.id == updated.id);
    state = [
      for (final t in state)
        if (t.id == updated.id) serverUpdated else t,
      if (!exists) serverUpdated,
    ];
  }

  Future<void> deleteTask(int id) async {
    await service.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }
}
