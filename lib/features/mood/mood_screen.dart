import 'package:flutter/material.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/services/mood_logger.dart'; // imaginary module
import 'package:humble_time_app/services/pacing_controller.dart'; // imaginary module

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  // Emoji options with semantic labels
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
    VoiceService.speak(PromptLibrary.forEvent('moodPrompt'));
  }

  void handleMoodTap(String emoji, String label) async {
    debugPrint('Mood selected: $emoji ($label)');
    await VoiceService.speak(PromptLibrary.forEvent('moodSelected', param: label));

    // 💾 Mood feedback and pacing response
    MoodLogger.saveMood(label);
    PacingController.adjustBasedOnMood(label);

    // 🧭 Optional navigation
    // context.go('/schedule');
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
