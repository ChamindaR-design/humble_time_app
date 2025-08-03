import 'package:flutter/material.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:hive/hive.dart';
import 'package:humble_time_app/models/log_entry.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final Map<String, String> moods = {
    '🙂': 'Happy',
    '😐': 'Neutral',
    '😕': 'Confused',
    '😢': 'Sad',
    '😄': 'Joyful',
  };

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    await VoiceService.init();
    await VoiceService.speak(PromptLibrary.forEvent('moodPrompt'));
  }

  Future<void> handleMoodTap(String emoji, String label) async {
    debugPrint('Mood selected: $emoji ($label)');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected mood: $label'),
        duration: const Duration(seconds: 1),
      ),
    );

    // Delay to avoid overlapping with snackbar animation
    await Future.delayed(const Duration(milliseconds: 300));
    await VoiceService.speak(PromptLibrary.forEvent('moodSelected', param: label));

    try {
      final box = Hive.box<LogEntry>('logEntries');
      final latest = box.values.isNotEmpty ? box.values.last : null;

      if (latest != null) {
        latest.mood = label;
        await latest.save();
        debugPrint('Mood saved to latest LogEntry.');
      } else {
        debugPrint('No LogEntry found to associate mood with.');
      }
    } catch (e) {
      debugPrint('Error saving mood: $e');
    }

    // Optional navigation or pacing logic can go here
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16),
        children: moods.entries.map((entry) {
          final emoji = entry.key;
          final label = entry.value;

          return Semantics(
            label: "Mood: $label",
            button: true,
            child: InkWell(
              onTap: () => handleMoodTap(emoji, label),
              borderRadius: BorderRadius.circular(8),
              splashColor: const Color.fromRGBO(0, 128, 128, 0.3),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
