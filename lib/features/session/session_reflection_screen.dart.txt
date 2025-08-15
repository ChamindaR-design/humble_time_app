import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/models/log_entry.dart';

class ReflectionScreen extends StatefulWidget {
  final LogEntry entry;

  const ReflectionScreen({super.key, required this.entry});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
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
    _speakAffirmation();
    _noteController.text = widget.entry.note ?? '';
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
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 24)),
                  selected: mood == emoji,
                  onSelected: (_) => setState(() => mood = emoji),
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
            ElevatedButton.icon(
              onPressed: () {
                final updatedNote = _noteController.text.trim();
                final updatedEntry = widget.entry.copyWith(
                  mood: mood.isNotEmpty ? mood : null,
                  note: updatedNote.isNotEmpty ? updatedNote : null,
                );

                // TODO: save to local or remote store here
                // e.g. await logStore.saveEntry(updatedEntry);

                Navigator.pop(context, updatedEntry);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save & Return'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}
