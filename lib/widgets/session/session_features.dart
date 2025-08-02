import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SessionType { focus, breakMode }
enum MoodType { calm, focused, distracted, energized }

class SessionFeatures extends StatefulWidget {
  final int currentBlock;
  final int totalBlocks;

  const SessionFeatures({
    super.key,
    required this.currentBlock,
    required this.totalBlocks,
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
    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final mood = selectedMood.name;
    final notes = journalController.text;
    final csvLine = '$now,${sessionType.name},$mood,$notes\n';
    // You can write this to file or DB here. Placeholder:
    debugPrint('Logged: $csvLine');
  }

  void _promptReflection() async {
    await tts.speak('How do you feel right now?');
    if (!mounted) return; // ✅ Prevent use of context after dispose

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reflect on Your Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<MoodType>(
              value: selectedMood,
              items: MoodType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                  .toList(),
              onChanged: (val) => setState(() => selectedMood = val!),
            ),
            TextField(
              controller: journalController,
              decoration: const InputDecoration(hintText: 'Write your thoughts...'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveJournalEntry();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadVoiceProfile();
    _saveStreak();
    if (widget.currentBlock == widget.totalBlocks) {
      Future.delayed(const Duration(milliseconds: 500), _promptReflection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text('Current streak: $streakCount days'),
      ],
    );
  }
}
