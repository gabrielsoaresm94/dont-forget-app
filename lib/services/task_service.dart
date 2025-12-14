import 'package:dio/dio.dart';
import 'package:dont_forget_app/utils/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';

final taskServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return TaskService(dio);
});

class TaskService {
  final Dio _dio;

  TaskService(this._dio);

  Future<TaskModel> getTask(int id) async {
    final res = await _dio.get('/tasks/v1/get/$id');
    return TaskModel.fromJson(res.data);
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final res = await _dio.post('/tasks/v1/create', data: task.toJson());
    return TaskModel.fromJson(res.data);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final res = await _dio.put(
      '/tasks/v1/update/${task.id}',
      data: task.toJson(),
    );
    return TaskModel.fromJson(res.data);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/tasks/v1/remove/$id');
  }
}
