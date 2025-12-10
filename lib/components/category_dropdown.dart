import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryAutocompleteDropdown extends ConsumerWidget {
  final int? selectedCategoryId;
  final ValueChanged<int> onChanged;

  const CategoryAutocompleteDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),

      error: (err, _) => const Text(
        "Erro ao carregar categorias",
        style: TextStyle(color: Colors.redAccent),
      ),

      data: (categories) {
        if (categories.isEmpty) {
          return const Text(
            "Nenhuma categoria disponível",
            style: TextStyle(color: Colors.white),
          );
        }

        // Categoria selecionada
        final selectedCategory = categories.firstWhere(
          (c) => c.id == selectedCategoryId,
          orElse: () => categories.first,
        );

        return Autocomplete<CategoryModel>(
          initialValue: TextEditingValue(
            text: selectedCategoryId != null ? selectedCategory.name : "",
          ),

          displayStringForOption: (c) => c.name,

          optionsBuilder: (value) {
            if (value.text.isEmpty) return categories;
            return categories.where(
              (c) => c.name.toLowerCase().contains(value.text.toLowerCase()),
            );
          },

          onSelected: (value) => onChanged(value.id),

          fieldViewBuilder: (context, controller, focusNode, _) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                fontFamily: 'OCRAStd',
                color: Color(0xFFDEDEDE),
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                hintText: "Categoria",
                hintStyle: TextStyle(color: Color(0x55DEDEDE)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                ),
              ),
            );
          },

          optionsViewBuilder: (context, onSelected, options) {
            return Material(
              color: const Color(0xFF1E1E1E),
              elevation: 6,
              child: ListView(
                padding: EdgeInsets.zero,
                children: options.map((c) {
                  return ListTile(
                    title: Text(
                      c.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => onSelected(c),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
