import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryAutocompleteDropdown extends ConsumerStatefulWidget {
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;

  const CategoryAutocompleteDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  ConsumerState<CategoryAutocompleteDropdown> createState() =>
      _CategoryAutocompleteDropdownState();
}

class _CategoryAutocompleteDropdownState
    extends ConsumerState<CategoryAutocompleteDropdown> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega as categorias uma vez (igual você faz com tasks)
    Future.microtask(() {
      ref.read(categoryProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    // Atualiza o campo quando há seleção (após carregar as categorias)
    if (widget.selectedCategoryId != null && categories.isNotEmpty) {
      final selected = categories.firstWhere(
        (c) => c.id == widget.selectedCategoryId,
        orElse: () => categories.first,
      );

      if (_controller.text != selected.name) {
        _controller.text = selected.name;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Autocomplete<CategoryModel>(
                displayStringForOption: (c) => c.name,
                optionsBuilder: (value) {
                  if (categories.isEmpty) return const Iterable.empty();

                  if (value.text.isEmpty) return categories;

                  final query = value.text.toLowerCase();
                  return categories.where(
                    (c) => c.name.toLowerCase().contains(query),
                  );
                },
                onSelected: (category) {
                  _controller.text = category.name;
                  widget.onChanged(category.id);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      // Mantém o controller interno do Autocomplete sincronizado
                      if (controller.text != _controller.text) {
                        controller.text = _controller.text;
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      }

                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(
                          fontFamily: 'OCRAStd',
                          color: Color(0xFFDEDEDE),
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Selecione uma categoria",
                          hintStyle: TextStyle(color: Color(0x55DEDEDE)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                          ),
                        ),
                        onChanged: (text) => _controller.text = text,
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  if (options.isEmpty) return const SizedBox.shrink();

                  return Material(
                    color: const Color(0xFF1E1E1E),
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
              ),
            ),

            // Botão para criar categoria
            _buildSquareButton(
              icon: Icons.check,
              onPressed: () => _createCategory(context),
            ),

            // Botão para editar categoria
            _buildSquareButton(
              icon: Icons.edit,
              onPressed: () => _openEditDialog(context, categories),
            ),
          ],
        ),
      ],
    );
  }

  // --- BOTÃO ESTILIZADO ---
  Widget _buildSquareButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDEDEDE)),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFFDEDEDE)),
        onPressed: onPressed,
      ),
    );
  }

  // --- CRIAR CATEGORIA ---
  Future<void> _createCategory(BuildContext context) async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    try {
      final created = await ref
          .read(categoryProvider.notifier)
          .createCategory(name);

      // Seleciona a categoria recém criada
      widget.onChanged(created.id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Categoria criada!')));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao criar categoria')));
    }
  }

  // --- EDITAR / REMOVER CATEGORIA ---
  void _openEditDialog(BuildContext context, List<CategoryModel> categories) {
    final selectedId = widget.selectedCategoryId;
    if (selectedId == null || categories.isEmpty) return;

    final category = categories.firstWhere((c) => c.id == selectedId);

    final editCtrl = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A1A),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editCtrl,
                  style: const TextStyle(
                    fontFamily: 'OCRAStd',
                    color: Color(0xFFDEDEDE),
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Editar
                    _buildDialogButton(
                      label: "Salvar",
                      color: Colors.greenAccent,
                      onPressed: () async {
                        final name = editCtrl.text.trim();
                        if (name.isEmpty) return;

                        await ref
                            .read(categoryProvider.notifier)
                            .updateCategory(category.id, name);

                        // Se estiver editando a selecionada, sincroniza texto
                        if (widget.selectedCategoryId == category.id) {
                          _controller.text = name;
                        }

                        Navigator.pop(context);
                      },
                    ),

                    // Remover
                    _buildDialogButton(
                      label: "Remover",
                      color: Colors.redAccent,
                      onPressed: () async {
                        await ref
                            .read(categoryProvider.notifier)
                            .deleteCategory(category.id);

                        // Se removeu a selecionada, limpa
                        if (widget.selectedCategoryId == category.id) {
                          widget.onChanged(null);
                          _controller.clear();
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'OCRAStd',
            color: Color(0xFFDEDEDE),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
