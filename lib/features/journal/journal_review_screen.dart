import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:humble_time_app/utils/export_import_service.dart';
import 'package:audioplayers/audioplayers.dart';

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
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('journalEntries') ?? [];

    if (!mounted) return;
    setState(() {
      _entries =
          stored.map((e) => jsonDecode(e)).cast<Map<String, dynamic>>().toList();
    });
  }

  Future<void> _playVoiceMemo(String path) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(path));
  }

  Widget _buildEntriesList() {
    return _entries.isEmpty
        ? const Center(child: Text('No journal entries found'))
        : ListView.builder(
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              final entry = _entries[index];
              final formattedDate = DateFormat.yMMMd().add_jm().format(
                DateTime.parse(entry['timestamp']),
              );
              final voicePath = entry['voiceMemoPath'];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry['text'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text("Mood: ${entry['mood']}",
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text("🕒 $formattedDate",
                          style: Theme.of(context).textTheme.bodySmall),
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
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal Review")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Export to JSON"),
                  onPressed: () async {
                    final file = await ExportImportService.exportEntriesToJson(_entries);
                    if (!mounted) return;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Exported to ${file.path}')),
                      );
                    }
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Import from JSON"),
                  onPressed: () async {
                    final imported = await ExportImportService.importEntriesFromJson();
                    if (imported != null) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setStringList(
                        'journalEntries',
                        imported.map((e) => jsonEncode(e)).toList(),
                      );
                      if (!mounted) return;
                      setState(() => _entries = imported);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Journal entries imported')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(child: _buildEntriesList()),
        ],
      ),
    );
  }
}
