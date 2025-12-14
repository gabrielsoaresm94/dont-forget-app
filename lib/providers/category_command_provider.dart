import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_query_provider.dart';
import 'package:dont_forget_app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryCommandProvider = Provider<CategoryCommand>((ref) {
  return CategoryCommand(
    service: ref.read(categoryServiceProvider),
    refresh: () => ref.read(categoryQueryProvider.notifier).load(),
  );
});

class CategoryCommand {
  final CategoryService service;
  final Future<void> Function() refresh;

  CategoryCommand({required this.service, required this.refresh});

  Future<void> create(String name) async {
    await service.createCategory(CategoryModel(id: 0, name: name));
    _eventualRefresh();
  }

  Future<void> update(int id, String name) async {
    await service.updateCategory(CategoryModel(id: id, name: name));
    _eventualRefresh();
  }

  Future<void> delete(int id) async {
    await service.deleteCategory(id);
    _eventualRefresh();
  }

  void _eventualRefresh() async {
    // respeita consistência eventual
    await Future.delayed(const Duration(milliseconds: 400));
    refresh();
  }
}
