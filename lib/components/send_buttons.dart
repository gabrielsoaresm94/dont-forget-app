import 'package:flutter/material.dart';

class SendButtons extends StatelessWidget {
  final VoidCallback onSend;
  final VoidCallback onHome;
  final VoidCallback onList;
  final double buttonSize;

  const SendButtons({
    super.key,
    required this.onSend,
    required this.onHome,
    required this.onList,
    this.buttonSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: onSend,
            borderRadius: BorderRadius.zero,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDEDEDE)),
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
            _iconButton(Icons.home_rounded, onHome),
            _iconButton(Icons.list_rounded, onList),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDEDEDE)),
        ),
        child: Icon(icon, size: 28, color: const Color(0xFFDEDEDE)),
      ),
    );
  }
}
