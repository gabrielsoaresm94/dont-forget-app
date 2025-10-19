import 'package:flutter/material.dart';

class TaskService {
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
}
