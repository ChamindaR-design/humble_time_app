import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:humble_time_app/utils/export_import_service.dart';
import 'package:humble_time_app/services/voice_service.dart';

class JournalReviewScreen extends StatefulWidget {
  const JournalReviewScreen({super.key});

  @override
  State<JournalReviewScreen> createState() => _JournalReviewScreenState();
}

class _JournalReviewScreenState extends State<JournalReviewScreen> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
    Future.microtask(() {
      if (mounted) {
        VoiceService.speakIfEnabled("Reviewing your saved reflections.");
      }
    });
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('journalEntries') ?? [];

    if (!mounted) return;
    setState(() {
      _entries = stored.map((e) => jsonDecode(e)).cast<Map<String, dynamic>>().toList();
    });
  }

  Future<void> _playVoiceMemo(String path) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(path));
    if (mounted) {
      VoiceService.speakIfEnabled("Playing voice memo.");
    }
  }

  Future<void> _exportEntries() async {
    final messenger = ScaffoldMessenger.of(context);
    final file = await ExportImportService.exportEntriesToJson(_entries);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
  }

  Future<void> _importEntries() async {
    final messenger = ScaffoldMessenger.of(context);
    final imported = await ExportImportService.importEntriesFromJson();
    if (imported == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'journalEntries',
      imported.map((e) => jsonEncode(e)).toList(),
    );

    if (!mounted) return;
    setState(() => _entries = imported);
    VoiceService.speakIfEnabled("Imported journal entries.");
    messenger.showSnackBar(const SnackBar(content: Text('Journal entries imported')));
  }

  Widget _buildEntriesList() {
    if (_entries.isEmpty) {
      return const Center(child: Text('No journal entries found'));
    }

    return ListView.builder(
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final formattedDate = DateFormat.yMMMd().add_jm().format(
          DateTime.parse(entry['timestamp']),
        );
        final voicePath = entry['voiceMemoPath'];

        return Semantics(
          label: 'Entry with mood ${entry['mood']}, saved on $formattedDate',
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['text'] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mood: ${entry['mood']}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "🕒 $formattedDate",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (voicePath != null && voicePath.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        tooltip: 'Play Voice Memo',
                        onPressed: () => _playVoiceMemo(voicePath),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Export to JSON"),
                onPressed: _exportEntries,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Import from JSON"),
                onPressed: _importEntries,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(child: _buildEntriesList()),
      ],
    );
  }
}
