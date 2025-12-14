import 'package:dio/dio.dart';
import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/services/category_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryModel>>((ref) {
      return CategoryNotifier(ref.read(categoryServiceProvider));
    });

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {
  final CategoryService service;

  CategoryNotifier(this.service) : super([]);

  Future<void> loadCategories() async {
    final categories = await service.getCategories();
    state = categories;
  }

  Future<void> loadCategory(int id) async {
    try {
      final category = await service.getCategory(id);
      state = [
        for (final c in state)
          if (c.id == id) category else c,
        if (!state.any((c) => c.id == id)) category,
      ];
    } on DioException {
      rethrow;
    }
  }

  Future<void> createCategory(String name) async {
    try {
      final command = CategoryModel(id: 0, name: name);
      await service.createCategory(command);
      await loadCategories();
    } on DioException {
      rethrow;
    }
  }

  Future<void> updateCategory(int id, String name) async {
    try {
      final command = CategoryModel(id: id, name: name);
      await service.updateCategory(command);
      await loadCategories();
    } on DioException {
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await service.deleteCategory(id);
      await loadCategories();
    } on DioException {
      rethrow;
    }
  }
}
