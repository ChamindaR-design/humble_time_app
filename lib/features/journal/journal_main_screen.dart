import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/widgets/prompt_bubble.dart';
import 'package:humble_time_app/widgets/voice_recorder_button.dart';
import 'package:humble_time_app/widgets/transcription_display.dart';
import 'package:humble_time_app/widgets/mood_tag_selector.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:humble_time_app/services/journal_service.dart';
import 'package:humble_time_app/models/journal_entry.dart';

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
    final status = await Permission.microphone.request();

    if (!mounted) return;
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission denied")),
      );
      return;
    }

    final available = await _speech.initialize();
    if (!mounted) return;

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() => _transcribedText = result.recognizedWords);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition not available")),
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() => _isListening = false);
  }

  Future<void> _saveReflection() async {
    final entry = JournalEntry(
      timestamp: DateTime.now(),
      moodLabel: _mood,
      reflection: _transcribedText,
      blockTags: [],
    );

    await JournalService().init();
    await JournalService().saveEntry(entry);

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
    context.go('/journal-review');
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime =
    DateFormat.yMMMd().add_jm().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text("Prompted Journaling")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text("🕒 $formattedTime"),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveReflection,
                              child: const Text("Save"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _navigateToReview,
                              child: const Text("Review"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.go('/'),
                              child: const Text("Home"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
