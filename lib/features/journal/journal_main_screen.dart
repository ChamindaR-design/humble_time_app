import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/widgets/prompt_bubble.dart';
import 'package:humble_time_app/widgets/voice_recorder_button.dart';
import 'package:humble_time_app/widgets/transcription_display.dart';
import 'package:humble_time_app/widgets/mood_tag_selector.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // ✅ New import for formatted timestamp

class JournalMainScreen extends StatefulWidget {
  const JournalMainScreen({super.key});

  @override
  State<JournalMainScreen> createState() => _JournalMainScreenState();
}

class _JournalMainScreenState extends State<JournalMainScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String _transcribedText = '';
  bool _isListening = false;
  String _mood = 'Neutral';

  @override
  void initState() {
    super.initState();
    _speakPrompt();
  }

  Future<void> _speakPrompt() async {
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("What made you smile today?");
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _transcribedText = result.recognizedWords);
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _saveReflection() async {
    final entry = {
      'text': _transcribedText,
      'mood': _mood,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('journalEntries') ?? [];
    existing.add(jsonEncode(entry));
    await prefs.setStringList('journalEntries', existing);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved')),
    );

    setState(() {
      _transcribedText = '';
      _mood = 'Neutral';
    });
  }

  void _navigateToReview() {
    context.push('/journal-review');
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat.yMMMd().add_jm().format(DateTime.now()); // 🕒 Prettified time

    return Scaffold(
      appBar: AppBar(title: const Text("Prompted Journaling")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PromptBubble(onReplay: _speakPrompt),
            const SizedBox(height: 20),
            VoiceRecorderButton(
              isListening: _isListening,
              onStart: _startListening,
              onStop: _stopListening,
            ),
            const SizedBox(height: 20),
            TranscriptionDisplay(text: _transcribedText),
            const SizedBox(height: 20),
            MoodTagSelector(
              selectedMood: _mood,
              onMoodChanged: (value) =>
                  setState(() => _mood = value ?? 'Neutral'),
            ),
            const SizedBox(height: 10),
            Text("🕒 $formattedTime"), // 🕒 Human-friendly timestamp
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveReflection,
                  child: const Text("Save Reflection"),
                ),
                OutlinedButton(
                  onPressed: _navigateToReview,
                  child: const Text("Review Entries"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
