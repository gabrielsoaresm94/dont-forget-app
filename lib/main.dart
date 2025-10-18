import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utilitarian Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF131313),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFDEDEDE),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final double buttonSize = 64;
  String _selectedCategory = "TRABALHO";

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    debugPrint("Enviado: $text");
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
              Expanded(
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    textAlign: TextAlign.left,
                    cursorColor: const Color(0xFFDEDEDE),
                    cursorWidth: 4,
                    cursorRadius: Radius.zero,
                    style: GoogleFonts.questrial(
                      color: const Color(0xFFDEDEDE),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDEDEDE), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF131313),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFDEDEDE),
                    ),
                    value: _selectedCategory,
                    items: ['TRABALHO', 'PESSOAL', 'ESTUDOS', 'OUTROS']
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat,
                              style: GoogleFonts.questrial(
                                color: const Color(0xFFDEDEDE),
                                fontSize: 20,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value ?? "");
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: const Color(0xFF131313),
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFFDEDEDE),
                                  onSurface: Color(0xFFDEDEDE),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 56,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDEDEDE),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'DATA',
                          style: GoogleFonts.questrial(
                            color: const Color(0xFFDEDEDE),
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: const Color(0xFF131313),
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFFDEDEDE),
                                  onSurface: Color(0xFFDEDEDE),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 56,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDEDEDE),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'HORA',
                          style: GoogleFonts.questrial(
                            color: const Color(0xFFDEDEDE),
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => debugPrint("Enviar task"),
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFDEDEDE),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.north_east_rounded,
                      size: 28,
                      color: Color(0xFFDEDEDE),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: buttonSize),
                  InkWell(
                    onTap: () => debugPrint("Ir para Home"),
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFDEDEDE),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 28,
                        color: Color(0xFFDEDEDE),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => debugPrint("Ir para lista de tasks"),
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFDEDEDE),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.list_rounded,
                        size: 28,
                        color: Color(0xFFDEDEDE),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
