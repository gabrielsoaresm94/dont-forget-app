import 'package:dont_forget_app/models/category_model.dart';
import 'package:dont_forget_app/providers/category_command_provider.dart';
import 'package:dont_forget_app/providers/category_query_provider.dart';
import 'package:dont_forget_app/services/category_service.dart';
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
    final async = ref.watch(categoryQueryProvider);
    final categories = async.value ?? const <CategoryModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAutocomplete(categories),

        if (async.isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: LinearProgressIndicator(minHeight: 2),
          ),

        if (async.hasError)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'Erro ao carregar categorias',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
      ],
    );
  }

  Widget _buildAutocomplete(List<CategoryModel> categories) {
    // Sincroniza seleção externa SEM estragar a digitação do usuário
    if (!_focusNode.hasFocus && widget.selectedCategoryId != null) {
      final match = categories
          .where((c) => c.id == widget.selectedCategoryId)
          .toList();

      if (match.isNotEmpty) {
        final next = match.first;
        final shouldUpdateText =
            _selected?.id != next.id || _controller.text != next.name;

        if (shouldUpdateText) {
          _selected = next;
          _controller.text = next.name;
        }
      }
    }

    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return RawAutocomplete<CategoryModel>(
                textEditingController: _controller,
                focusNode: _focusNode,
                displayStringForOption: (c) => c.name,

                optionsBuilder: (value) {
                  final text = value.text.trim().toLowerCase();
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
                    onTap: () {
                      // Força o autocomplete a mostrar opções mesmo sem digitar
                      controller.value = controller.value.copyWith(
                        text: controller.text,
                        selection: TextSelection.collapsed(
                          offset: controller.text.length,
                        ),
                        composing: TextRange.empty,
                      );
                    },
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
                      child: SizedBox(
                        width: constraints.maxWidth,
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
                    ),
                  );
                },
              );
            },
          ),
        ),
        _iconButton(Icons.check, _createCategory),
        _iconButton(
          Icons.edit,
          _selected == null ? null : () => _openEditDialog(context),
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

    // Como o command não retorna objeto, esperamos o read-model “enxergar” via GET
    final created = await _waitForCategoryByName(name);

    if (!mounted) return;

    if (created != null) {
      _selected = created;
      _controller.text = created.name;
      widget.onChanged(created.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoria criada e selecionada')),
      );
    } else {
      // Não apareceu a tempo (consistência eventual sendo… ela mesma)
      widget.onChanged(null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoria criada, mas ainda não apareceu na listagem'),
        ),
      );
    }
  }

  Future<CategoryModel?> _waitForCategoryByName(String name) async {
    final service = ref.read(categoryServiceProvider);
    final target = name.trim().toLowerCase();

    var delay = const Duration(milliseconds: 200);

    for (var i = 0; i < 10; i++) {
      await Future.delayed(delay);

      try {
        final list = await service.getCategories();
        final match = list.where((c) => c.name.trim().toLowerCase() == target);
        if (match.isNotEmpty) {
          // Atualiza o query provider também (pra UI inteira ficar consistente)
          await ref.read(categoryQueryProvider.notifier).load();
          return match.first;
        }
      } catch (_) {
        // se o query-side falhar, tentamos de novo
      }

      delay = Duration(milliseconds: (delay.inMilliseconds * 1.35).round());
    }

    // Mesmo que não tenha achado, pelo menos tentamos refrescar uma vez
    await ref.read(categoryQueryProvider.notifier).load();
    return null;
  }

  void _openEditDialog(BuildContext context) {
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

              final id = _selected!.id;

              await ref.read(categoryCommandProvider).update(id, name);

              if (!mounted) return;

              _selected = CategoryModel(id: id, name: name);
              _controller.text = name;

              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () async {
              final id = _selected!.id;

              await ref.read(categoryCommandProvider).delete(id);

              if (!mounted) return;

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
