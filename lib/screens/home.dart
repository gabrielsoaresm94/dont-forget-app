import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/task_input.dart';
import '../components/category_dropdown.dart';
import '../components/date_time_picker.dart';
import '../components/send_buttons.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedCategory = "TRABALHO";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _sendTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    TaskService().sendTask(
      description: text,
      category: _selectedCategory,
      date: _selectedDate,
      time: _selectedTime,
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NÃO POSSO\nESQUECER DE ...',
                style: GoogleFonts.questrial(
                  color: const Color(0xFFDEDEDE),
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              TaskInput(controller: _controller),
              const SizedBox(height: 20),
              CategoryDropdown(
                selectedCategory: _selectedCategory,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              DateTimePicker(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                onTimeSelected: (time) => setState(() => _selectedTime = time),
              ),
              SendButtons(
                onSend: _sendTask,
                onHome: () => Navigator.pushNamed(context, '/'),
                onList: () => Navigator.pushNamed(context, '/tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
