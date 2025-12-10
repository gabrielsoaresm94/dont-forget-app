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

  TaskNotifier(this.service) : super([]);

  /// Carrega uma task pelo ID e adiciona/atualiza no estado
  Future<void> loadTask(int id) async {
    final task = await service.getTask(id);

    state = [
      for (final t in state)
        if (t.id == id) task else t,
      if (!state.any((t) => t.id == id)) task,
    ];
  }

  /// Adiciona uma nova task criada via API
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

  /// Atualiza uma task existente
  Future<void> updateTask(TaskModel updated) async {
    final serverUpdated = await service.updateTask(updated);

    bool exists = state.any((t) => t.id == updated.id);

    state = [
      for (final t in state)
        if (t.id == updated.id) serverUpdated else t,
      if (!exists) serverUpdated,
    ];
  }

  /// Remove uma task do backend e do estado
  Future<void> deleteTask(int id) async {
    await service.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }
}
