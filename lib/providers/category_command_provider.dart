import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_query_provider.dart';
import 'package:dont_forget_app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryCommandProvider = Provider<CategoryCommand>((ref) {
  return CategoryCommand(
    service: ref.read(categoryServiceProvider),
    query: ref.read(categoryQueryProvider.notifier),
  );
});

class CategoryCommand {
  final CategoryService service;
  final CategoryQuery query;

  CategoryCommand({required this.service, required this.query});

  Future<void> create(String name) async {
    await service.createCategory(CategoryModel(id: 0, name: name));
    await _eventualReload();
  }

  Future<void> update(int id, String name) async {
    await service.updateCategory(CategoryModel(id: id, name: name));
    await _eventualReload();
  }

  Future<void> delete(int id) async {
    await service.deleteCategory(id);
    await _eventualReload();
  }

  Future<void> _eventualReload() async {
    await Future.delayed(const Duration(milliseconds: 700));
    await query.load();
  }
}
