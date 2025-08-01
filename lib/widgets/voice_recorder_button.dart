import 'package:flutter/material.dart';

class VoiceRecorderButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const VoiceRecorderButton({
    super.key,
    required this.isListening,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(isListening ? Icons.stop : Icons.mic),
      label: Text(isListening ? "Stop Recording" : "Start Recording"),
      onPressed: isListening ? onStop : onStart,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}
