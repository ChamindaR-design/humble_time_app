import 'package:flutter/material.dart';

class TranscriptionDisplay extends StatelessWidget {
  final String text;

  const TranscriptionDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty
          ? "Your words will appear here..."
          : text,
      style: const TextStyle(fontSize: 16),
    );
  }
}
