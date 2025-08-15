import 'package:flutter/material.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/helpers/mood_resolver.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:hive/hive.dart';
import 'package:humble_time_app/models/log_entry.dart';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final List<String> moodKeys = ['happy', 'neutral', 'confused', 'sad', 'joyful'];

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    await VoiceService.init();
    final prompt = await PromptLibrary.forEvent('moodPrompt', locale);
    await VoiceService.speak(prompt);
  }

  Future<void> handleMoodTap(String key) async {
    final locale = Localizations.localeOf(context);
    final label = MoodResolver.localizedLabel(context, key);
    final emoji = MoodResolver.emojiFromKey(key) ?? '';

    debugPrint('Mood selected: $emoji ($key)');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected mood: $label'), duration: const Duration(seconds: 1)),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    final confirmation = await PromptLibrary.forEvent('moodSelected', locale, param: label);
    await VoiceService.speak(confirmation);

    try {
      final box = Hive.box<LogEntry>('logEntries');
      final latest = box.values.isNotEmpty ? box.values.last : null;

      if (latest != null) {
        latest.mood = key; // ✅ Save raw key
        await latest.save();
        debugPrint('Mood saved to latest LogEntry.');
      } else {
        debugPrint('No LogEntry found to associate mood with.');
      }
    } catch (e) {
      debugPrint('Error saving mood: $e');
    }
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Mood Tracker')),
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
          onPressed: () {
            HapticFeedback.selectionClick();
            VoiceService.speak("Returning to Home");
            context.go('/');
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16),
        children: moodKeys.map((key) {
          final emoji = MoodResolver.emojiFromKey(key)!;
          final label = MoodResolver.localizedLabel(context, key);

          return Semantics(
            label: "Mood: $label",
            button: true,
            child: InkWell(
              onTap: () => handleMoodTap(key),
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
