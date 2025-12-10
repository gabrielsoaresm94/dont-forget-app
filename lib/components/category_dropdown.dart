import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class CategoryDropdown extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDEDEDE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF131313),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFDEDEDE)),
          value: selectedCategory,
          items: ['TRABALHO', 'PESSOAL', 'ESTUDOS', 'OUTROS']
              .map(
                (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(
                    cat,
                    style: const TextStyle(
                      fontFamily: 'OCRAStd',
                      color: Color(0xFFDEDEDE),
                      fontSize: 20,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => onChanged(value ?? "TRABALHO"),
        ),
      ),
    );
  }
}
