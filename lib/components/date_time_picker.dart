import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimePicker extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const DateTimePicker({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// --- SELETOR DE DATA ---
        Expanded(
          child: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Color(0xFFDEDEDE),
                        surface: Color(0xFF1A1A1A),
                        onSurface: Color(0xFFDEDEDE),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) onDateSelected(date);
            },
            child: _buildBox(
              selectedDate != null
                  ? "${selectedDate!.day.toString().padLeft(2, '0')}/"
                        "${selectedDate!.month.toString().padLeft(2, '0')}/"
                        "${selectedDate!.year}"
                  : "DATA",
            ),
          ),
        ),

        /// --- SELETOR DE HORA ---
        Expanded(
          child: InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Color(0xFFDEDEDE),
                        surface: Color(0xFF1A1A1A),
                        onSurface: Color(0xFFDEDEDE),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) onTimeSelected(time);
            },
            child: _buildBox(
              selectedTime != null ? selectedTime!.format(context) : "HORA",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBox(String text) {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDEDEDE)),
      ),
      child: Text(
        text,
        style: GoogleFonts.questrial(
          color: const Color(0xFFDEDEDE),
          fontSize: 20,
        ),
      ),
    );
  }
}
