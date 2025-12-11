import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final Color color;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: value ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
      ),
    );
  }
}
