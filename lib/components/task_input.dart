import 'package:flutter/material.dart';

class TaskInput extends StatelessWidget {
  final TextEditingController controller;

  const TaskInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: TextField(
          controller: controller,
          maxLines: null,
          textAlign: TextAlign.left,
          cursorColor: const Color(0xFFDEDEDE),
          cursorWidth: 4,
          cursorRadius: Radius.zero,
          style: const TextStyle(
            fontFamily: 'OCRAStd',
            color: Color(0xFFDEDEDE),
            fontSize: 42,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            height: 1.3,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            labelText: 'MINHA TASK',
            labelStyle: TextStyle(color: Color(0xFFDEDEDE)),
          ),
        ),
      ),
    );
  }
}
