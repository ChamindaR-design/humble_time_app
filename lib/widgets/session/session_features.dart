import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:humble_time_app/shared_prefs/save_reflection.dart'; // Ensure this path is correct

enum SessionType { focus, breakMode }
enum MoodType { calm, focused, distracted, energized }

class SessionFeatures extends StatefulWidget {
  final int currentBlock;
  final int totalBlocks;
  final Reflection? reflection; // ✅ Add this

  const SessionFeatures({
    super.key,
    required this.currentBlock,
    required this.totalBlocks,
    this.reflection, // ✅ Include it here
  });

  @override
  State<SessionFeatures> createState() => _SessionFeaturesState();
}

class _SessionFeaturesState extends State<SessionFeatures> {
  final FlutterTts tts = FlutterTts();
  MoodType selectedMood = MoodType.focused;
  TextEditingController journalController = TextEditingController();
  SessionType sessionType = SessionType.focus;
  int streakCount = 0;
  String? lastReflectionNote;
  String? lastReflectionMood;
  String? lastReflectionTimestamp;

  Future<void> _loadVoiceProfile() async {
    final prefs = await SharedPreferences.getInstance();
    double pitch = prefs.getDouble('pitch') ?? 1.0;
    double rate = prefs.getDouble('rate') ?? 0.5;
    await tts.setPitch(pitch);
    await tts.setSpeechRate(rate);
  }

  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = prefs.getString('lastPacedDate');
    if (lastDate == today) return;
    if (lastDate == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))) {
      streakCount = (prefs.getInt('streakCount') ?? 0) + 1;
    } else {
      streakCount = 1;
    }
    await prefs.setString('lastPacedDate', today);
    await prefs.setInt('streakCount', streakCount);
  }

  Future<void> _saveJournalEntry() async {
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final mood = selectedMood.name;
    final notes = journalController.text.isEmpty
        ? "Session ended smoothly."
        : journalController.text;

    await saveReflection(
      currentBlock: widget.currentBlock,
      intention: mood,
      breathingStyle: sessionType.name,
      note: notes,
    );

    setState(() {
      lastReflectionTimestamp = timestamp;
      lastReflectionMood = mood;
      lastReflectionNote = notes;
    });

    journalController.clear();
    debugPrint('✅ Reflection saved: $timestamp | $mood | $notes');
  }

/*  Future<void> _loadLastReflection() async {
    final reflection = await loadLatestReflection();
    if (reflection != null && mounted) {
      setState(() {
        lastReflectionTimestamp = reflection.timestamp;
        lastReflectionMood = reflection.intention;
        lastReflectionNote = reflection.note;
      });
    }
  }*/

  Future<void> _loadLastReflection() async {
    final reflection = widget.reflection ?? await loadLatestReflection();
    if (reflection != null && mounted) {
      setState(() {
        lastReflectionTimestamp = reflection.timestamp;
        lastReflectionMood = reflection.intention;
        lastReflectionNote = reflection.note;
      });
    }
  }

  String getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return '🧘';
      case 'focused':
        return '🎯';
      case 'distracted':
        return '😵';
      case 'energized':
        return '⚡';
      default:
        return '✨';
    }
  }

  void _promptReflection() async {
    await tts.speak('How do you feel right now?');
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        MoodType tempMood = selectedMood;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Reflect on Your Session'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<MoodType>(
                  value: tempMood,
                  items: MoodType.values
                      .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                      .toList(),
                  onChanged: (val) => setState(() => tempMood = val!),
                ),
                TextField(
                  controller: journalController,
                  decoration: const InputDecoration(hintText: 'Write your thoughts...'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  selectedMood = tempMood;
                  _saveJournalEntry();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadVoiceProfile();
    _saveStreak();
    _loadLastReflection();
    if (widget.currentBlock == widget.totalBlocks) {
      Future.delayed(const Duration(milliseconds: 500), _promptReflection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<SessionType>(
          value: sessionType,
          items: SessionType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type == SessionType.focus ? 'Focus Mode' : 'Break Mode'),
            );
          }).toList(),
          onChanged: (val) => setState(() => sessionType = val!),
        ),
        const SizedBox(height: 8),
        Text('Blocks Completed: ${widget.currentBlock} of ${widget.totalBlocks}'),
        const SizedBox(height: 8),
        Text('Current streak: $streakCount days'),
        if (lastReflectionNote != null) ...[
          const SizedBox(height: 16),
          Text('📝 Reflection', style: Theme.of(context).textTheme.titleMedium),
          Text('Mood: ${getMoodEmoji(lastReflectionMood!)} $lastReflectionMood'),
          Text('Note: $lastReflectionNote'),
          Text('Saved at: $lastReflectionTimestamp'),
        ],
      ],
    );
  }
}
