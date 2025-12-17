import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final categoryQueryProvider =
    StateNotifierProvider<CategoryQuery, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoryQuery(ref.read(categoryServiceProvider)),
    );

class CategoryQuery extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryService service;

  CategoryQuery(this.service) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await service.getCategories();
    });
  }
}
