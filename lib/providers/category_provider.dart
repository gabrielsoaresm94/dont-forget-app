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

  Future<void> loadCategory(int id) async {
    final category = await service.getCategory(id);

    state = [
      for (final c in state)
        if (c.id == id) category else c,
      if (!state.any((c) => c.id == id)) category,
    ];
  }

  Future<void> loadCategories() async {
    final categories = await service.getCategories();
    state = categories;
  }

  Future<CategoryModel> createCategory(String name) async {
    final newCategory = CategoryModel(id: 0, name: name);
    final created = await service.createCategory(newCategory);
    state = [...state, created];
    return created;
  }

  Future<void> updateCategory(int id, String name) async {
    final updated = CategoryModel(id: id, name: name);
    final serverUpdated = await service.updateCategory(updated);
    final exists = state.any((c) => c.id == id);
    state = [
      for (final c in state)
        if (c.id == id) serverUpdated else c,
      if (!exists) serverUpdated,
    ];
  }

  Future<void> deleteCategory(int id) async {
    await service.deleteCategory(id);
    state = state.where((c) => c.id != id).toList();
  }
}
