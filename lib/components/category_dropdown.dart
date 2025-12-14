import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_command_provider.dart';
import 'package:dont_forget_app/providers/category_query_provider.dart';
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
  final FocusNode _focusNode = FocusNode();

  CategoryModel? _selected;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryQueryProvider);

    return state.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => const Text(
        'Erro ao carregar categorias',
        style: TextStyle(color: Colors.redAccent),
      ),
      data: _buildAutocomplete,
    );
  }

  Widget _buildAutocomplete(List<CategoryModel> categories) {
    // sincroniza seleção externa
    if (widget.selectedCategoryId != null) {
      _selected = categories.firstWhere(
        (c) => c.id == widget.selectedCategoryId,
        orElse: () => _selected ?? categories.first,
      );
      _controller.text = _selected!.name;
    }

    return Row(
      children: [
        Expanded(
          child: RawAutocomplete<CategoryModel>(
            textEditingController: _controller,
            focusNode: _focusNode,

            displayStringForOption: (c) => c.name,

            optionsBuilder: (value) {
              final text = value.text.toLowerCase();
              if (text.isEmpty) return categories;

              return categories.where(
                (c) => c.name.toLowerCase().contains(text),
              );
            },

            onSelected: (category) {
              _selected = category;
              widget.onChanged(category.id);
            },

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
                  hintText: 'Selecione uma categoria',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 21,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Color(0xFFDEDEDE)),
                  ),
                ),
                onChanged: (_) {
                  _selected = null;
                  widget.onChanged(null);
                },
              );
            },

            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: const Color(0xFF1E1E1E),
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(
                            option.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _iconButton(Icons.check, _createCategory),
        _iconButton(
          Icons.edit,
          _selected == null ? null : () => _openEditDialog(context, categories),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDEDEDE)),
        ),
        child: Icon(icon, color: const Color(0xFFDEDEDE)),
      ),
    );
  }

  Future<void> _createCategory() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    await ref.read(categoryCommandProvider).create(name);

    _controller.clear();
    widget.onChanged(null);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Categoria criada')));
  }

  void _openEditDialog(BuildContext context, List<CategoryModel> categories) {
    if (_selected == null) return;

    final editCtrl = TextEditingController(text: _selected!.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        content: TextField(
          controller: editCtrl,
          style: const TextStyle(color: Color(0xFFDEDEDE)),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = editCtrl.text.trim();
              if (name.isEmpty) return;

              await ref
                  .read(categoryCommandProvider)
                  .update(_selected!.id, name);

              _controller.text = name;
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(categoryCommandProvider).delete(_selected!.id);

              _controller.clear();
              widget.onChanged(null);
              _selected = null;

              Navigator.pop(context);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}
