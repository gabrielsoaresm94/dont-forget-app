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

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // ação de envio
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
                textAlign: TextAlign.left,
                style: GoogleFonts.questrial(
                  color: const Color(0xFFDEDEDE),
                  fontSize: 46,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _sendText,
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFDEDEDE),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.north_east_rounded, // mais "utilitário"
                      size: 28,
                      color: Color(0xFFDEDEDE),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
