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
    final data = res.data;

    if (data is Map && data['Data'] is Map) {
      return TaskModel.fromJson(Map<String, dynamic>.from(data['Data']));
    }
    if (data is Map<String, dynamic>) {
      return TaskModel.fromJson(data);
    }
    if (data is Map && data['data'] is Map) {
      return TaskModel.fromJson(Map<String, dynamic>.from(data['data']));
    }

    throw Exception('Resposta inválida em getTask');
  }

  Future<List<TaskModel>> getTasks() async {
    final res = await _dio.get('/tasks/v1/list');
    final data = res.data;

    List rawList;

    if (data is Map && data['Data'] is List) {
      rawList = data['Data'] as List;
    } else {
      return [];
    }

    return rawList
        .whereType<Map>()
        .map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> createTask(TaskModel task) async {
    await _dio.post('/tasks/v1/create', data: task.toJson());
  }

  Future<void> updateTask(TaskModel task) async {
    await _dio.put('/tasks/v1/update/${task.id}', data: task.toJson());
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/tasks/v1/delete/$id');
  }
}
