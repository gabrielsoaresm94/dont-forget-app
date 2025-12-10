import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

final categoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final service = ref.read(categoryServiceProvider);
  return await service.getCategories();
});
