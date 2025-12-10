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

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories/v1/list');

    final list = response.data as List;

    return list.map((c) => CategoryModel.fromJson(c)).toList();
  }
}
