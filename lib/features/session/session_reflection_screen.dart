import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/services/log_store.dart';
import 'package:humble_time_app/features/reflection/models/reflection_entry.dart';
import 'package:humble_time_app/features/reflection/services/reflection_store.dart';

class SessionReflectionScreen extends StatefulWidget {
  final LogEntry entry;

  const SessionReflectionScreen({super.key, required this.entry});

  @override
  State<SessionReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<SessionReflectionScreen> {
  final _noteController = TextEditingController();
  String mood = '';
  late final FlutterTts flutterTts;

  final List<String> affirmations = [
    'You did beautifully — your time matters.',
    'Every breath is progress.',
    'Focus is a skill, and you practiced it well.',
    'Rest is powerful. You chose wisely.',
  ];

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _configureTts();
    _speakAffirmation();
    _noteController.text = widget.entry.note ?? '';
  }

  void _configureTts() {
    flutterTts.setSpeechRate(0.5);
    flutterTts.setPitch(1.0);
    flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _speakAffirmation() async {
    final affirmation = (affirmations..shuffle()).first;
    await flutterTts.speak(affirmation);
  }

  Future<void> _speakReflection(String mood, String? note) async {
    final moodText = mood.isNotEmpty ? 'Mood: $mood.' : '';
    final noteText = note?.isNotEmpty ?? false ? 'Note: $note.' : '';
    final message = 'Reflection saved. $moodText $noteText';
    await flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      appBar: AppBar(title: const Text('Reflection')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${entry.blockType.name.toUpperCase()} block',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('Duration: ${_formatTime(entry.duration)}'),
            Text(entry.usedVoicePrompts ? 'Voice prompts: yes' : 'Voice prompts: no'),

            if (entry.note?.isNotEmpty ?? false) ...[
              const SizedBox(height: 24),
              Text('Session Journal:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(entry.note!, style: const TextStyle(fontStyle: FontStyle.italic)),
            ],

            const SizedBox(height: 24),
            Text('How are you feeling?', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 12,
              children: ['😊', '😐', '😕', '😴', '💪'].map((emoji) {
                return Semantics(
                  label: 'Feeling $emoji',
                  child: ChoiceChip(
                    label: Text(emoji, style: const TextStyle(fontSize: 24)),
                    selected: mood == emoji,
                    onSelected: (_) => setState(() => mood = emoji),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Optional reflection',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            Semantics(
              label: 'Save reflection and return',
              child: ElevatedButton.icon(
                onPressed: () async {
                  final localContext = context;

                  final updatedNote = _noteController.text.trim();
                  if (mood.isEmpty && updatedNote.isEmpty) {
                    ScaffoldMessenger.of(localContext).showSnackBar(
                      const SnackBar(content: Text('Please select a mood or enter a note')),
                    );
                    return;
                  }

                  final updatedEntry = widget.entry.copyWith(
                    mood: mood.isNotEmpty ? mood : null,
                    note: updatedNote.isNotEmpty ? updatedNote : null,
                  );

                  await LogStore.instance.saveEntry(updatedEntry);

                  final reflection = ReflectionEntry(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    timestamp: DateTime.now(),
                    mood: updatedEntry.mood,
                    note: updatedEntry.note,
                  );

                  ReflectionStore.instance.save(reflection);

                  await _speakReflection(mood, updatedNote);

                  if (!localContext.mounted) return;

                  ScaffoldMessenger.of(localContext).showSnackBar(
                    const SnackBar(content: Text('Reflection saved')),
                  );

                  Navigator.pop(localContext, updatedEntry);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save & Return'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}
