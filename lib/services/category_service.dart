import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

final categoryServiceProvider = Provider((ref) => CategoryService());

class CategoryService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5000',
      headers: {
        "Authorization": "Bearer Token",
        "Content-Type": "application/json",
      },
    ),
  );

  Future<CategoryModel> getCategory(int id) async {
    final res = await _dio.get('/categories/v1/get/$id');
    return CategoryModel.fromJson(res.data);
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories/v1/list');
    final list = response.data as List;
    return list.map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    final res = await _dio.post(
      '/categories/v1/create',
      data: category.toJson(),
    );
    return CategoryModel.fromJson(res.data);
  }

  Future<CategoryModel> updateCategory(CategoryModel category) async {
    final res = await _dio.put(
      '/categories/v1/update/${category.id}',
      data: category.toJson(),
    );
    return CategoryModel.fromJson(res.data);
  }

  Future<void> deleteCategory(int id) async {
    await _dio.delete('/categories/v1/remove/$id');
  }
}
