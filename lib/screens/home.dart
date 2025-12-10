import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/task_input.dart';
import '../components/category_dropdown.dart';
import '../components/date_time_picker.dart';
import '../components/send_buttons.dart';
import '../providers/category_provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  int? _selectedCategoryId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _sendTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }

    // Agora podemos montar a data final corretamente
    final fullDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    await ref
        .read(taskProvider.notifier)
        .addTask(
          description: text,
          categoryId: _selectedCategoryId!,
          date: fullDate,
        );

    _controller.clear();
    Navigator.pushReplacementNamed(context, '/tasks');
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NÃO POSSO ESQUECER DE ...',
                style: TextStyle(
                  fontFamily: 'OCRAStd',
                  color: Color(0xFFDEDEDE),
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              TaskInput(controller: _controller),
              const SizedBox(height: 20),

              // Categories vindo da API
              CategoryAutocompleteDropdown(
                selectedCategoryId: _selectedCategoryId,
                onChanged: (id) => setState(() => _selectedCategoryId = id),
              ),

              DateTimePicker(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                onTimeSelected: (time) => setState(() => _selectedTime = time),
              ),

              SendButtons(
                onSend: _sendTask,
                onHome: () => Navigator.pushReplacementNamed(context, '/'),
                onList: () => Navigator.pushReplacementNamed(context, '/tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
