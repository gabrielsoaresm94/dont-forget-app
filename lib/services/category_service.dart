import 'package:dio/dio.dart';
import 'package:dont_forget_app/utils/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryService(dio);
});

class CategoryService {
  final Dio _dio;

  CategoryService(this._dio);

  Future<CategoryModel> getCategory(int id) async {
    final res = await _dio.get('/categories/v1/get/$id');
    return CategoryModel.fromJson(res.data);
  }

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get('/categories/v1/list');

    if (res.data is! List) {
      return [];
    }

    return (res.data as List).map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<void> createCategory(CategoryModel category) async {
    await _dio.post('/categories/v1/create', data: category.toJson());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _dio.put(
      '/categories/v1/update/${category.id}',
      data: category.toJson(),
    );
  }

  Future<void> deleteCategory(int id) async {
    await _dio.delete('/categories/v1/remove/$id');
  }
}
