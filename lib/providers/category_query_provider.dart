import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final categoryQueryProvider =
    StateNotifierProvider<
      CategoryQueryNotifier,
      AsyncValue<List<CategoryModel>>
    >((ref) => CategoryQueryNotifier(ref.read(categoryServiceProvider)));

class CategoryQueryNotifier
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryService service;

  CategoryQueryNotifier(this.service) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    // Mantém o valor anterior enquanto carrega (não some com o campo do usuário)
    state = const AsyncValue<List<CategoryModel>>.loading().copyWithPrevious(
      state,
    );

    try {
      final categories = await service.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
