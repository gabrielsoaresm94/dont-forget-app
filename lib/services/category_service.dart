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
    final data = res.data;

    if (data is Map<String, dynamic>) {
      return CategoryModel.fromJson(data);
    }
    if (data is Map && data['data'] is Map) {
      return CategoryModel.fromJson(Map<String, dynamic>.from(data['data']));
    }

    throw Exception('Resposta inválida em getCategory');
  }

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get('/categories/v1/list');
    final data = res.data;

    List rawList;

    if (data is List) {
      rawList = data;
    } else if (data is Map && data['data'] is List) {
      rawList = data['data'] as List;
    } else if (data is Map && data['items'] is List) {
      rawList = data['items'] as List;
    } else if (data is Map && data['categories'] is List) {
      rawList = data['categories'] as List;
    } else if (data is Map && data['Data'] is List) {
      rawList = data['Data'] as List;
    } else {
      return [];
    }

    return rawList
        .whereType<Map>()
        .map((c) => CategoryModel.fromJson(Map<String, dynamic>.from(c)))
        .toList();
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
    await _dio.delete('/categories/v1/delete/$id');
  }
}
