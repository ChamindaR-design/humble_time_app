import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

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

  void _speak(String message) async {
    await _flutterTts.speak(message);
  }

  void _handleSubmit() {
    final text = _entryController.text.trim();
    if (text.isNotEmpty) {
      _speak("Got it. Entry saved: $text");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entry saved successfully")),
      );
      _entryController.clear();
    } else {
      _speak("You haven’t typed anything yet.");
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
        TextField(
          controller: _entryController,
          decoration: const InputDecoration(
            labelText: "Your entry",
            border: OutlineInputBorder(),
          ),
          maxLines: null,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSubmit(),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text("Save Entry"),
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
