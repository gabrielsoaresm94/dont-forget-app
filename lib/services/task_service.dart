import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';

final taskServiceProvider = Provider((ref) => TaskService());

class TaskService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5000',
      headers: {
        "Authorization": "Bearer Token",
        "Content-Type": "application/json",
      },
    ),
  );

  Future<void> sendTask({
    required String description,
    required String category,
    DateTime? date,
    TimeOfDay? time,
  }) async {
    print("Enviando Task:");
    print("Descrição: $description");
    print("Categoria: $category");
    print("Data: ${date?.toIso8601String() ?? 'não definida'}");
    final formattedTime = time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : 'não definida';
    print("Hora: $formattedTime");
  }

  Future<TaskModel> getTask(int id) async {
    final res = await _dio.get('/tasks/v1/get/$id');
    return TaskModel.fromJson(res.data);
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final res = await _dio.post('/tasks/v1/create', data: task.toJson());
    return TaskModel.fromJson(res.data);
  }

  Future<TaskModel> updateTask(TaskModel updated) async {
    final res = await _dio.put(
      '/tasks/v1/update/${updated.id}',
      data: updated.toJson(),
    );
    return TaskModel.fromJson(res.data);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/tasks/v1/remove/$id');
  }
}
