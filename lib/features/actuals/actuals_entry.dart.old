import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ActualsEntryScreen extends StatefulWidget {
  const ActualsEntryScreen({super.key});

  @override
  ActualsEntryScreenState createState() => ActualsEntryScreenState();
}

class ActualsEntryScreenState extends State<ActualsEntryScreen> {
  final TextEditingController _entryController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    speakPrompt("Welcome back, Chaminda. What would you like to log?");
  }

  Future<void> speakPrompt(String message) async {
    await flutterTts.setLanguage("en-GB");
    //await flutterTts.setSpeechRate(0.9); // Optional: smoother delivery
    await flutterTts.setSpeechRate(0.6); // more conversational
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(message);
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final entryText = _entryController.text.trim();
    if (entryText.isNotEmpty) {
      // You can add logic here to save the entry to a database or backend
      speakPrompt("Got it. Entry saved: $entryText");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entry saved successfully")),
      );
      _entryController.clear();
    } else {
      speakPrompt("You haven’t typed anything yet.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Actuals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Log what you've completed so far.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _entryController,
              decoration: InputDecoration(
                labelText: "Your entry",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveEntry(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save Entry"),
              onPressed: _saveEntry,
            ),
          ],
        ),
      ),
    );
  }
}
