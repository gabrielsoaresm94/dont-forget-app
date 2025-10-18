import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      'Ligar para o fornecedor',
      'Enviar relatório mensal',
      'Comprar tinta branca',
      'Organizar arquivos de 2024',
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TASKS',
              style: GoogleFonts.questrial(
                color: const Color(0xFFDEDEDE),
                fontSize: 46,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDEDEDE)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Text(
                      tasks[index],
                      style: GoogleFonts.questrial(
                        color: const Color(0xFFDEDEDE),
                        fontSize: 18,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
