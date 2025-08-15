import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EntryForm extends StatefulWidget {
  final Future<void> Function(String) onSaved;

  const EntryForm({
    super.key,
    required this.onSaved,
  });

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final TextEditingController _entryController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _speak("Welcome back. What would you like to log?");
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-GB");
    await _flutterTts.setSpeechRate(0.6);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String message) async {
    await _flutterTts.speak(message);
  }

  Future<void> _handleSubmit() async {
    final text = _entryController.text.trim();
    if (text.isNotEmpty) {
      await widget.onSaved(text);
      await _speak("Nice work. Entry saved: $text");
      HapticFeedback.selectionClick();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Entry saved successfully")),
        );
      }
      _entryController.clear();
    } else {
      await _speak("You haven’t typed anything yet.");
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: 'Enter the details of your completed task',
          child: TextField(
            controller: _entryController,
            decoration: const InputDecoration(
              labelText: "Your entry",
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Save entry button',
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Entry"),
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }
}
