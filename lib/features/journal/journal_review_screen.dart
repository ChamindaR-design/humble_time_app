import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/models/journal_entry.dart';
import 'package:humble_time_app/services/journal_service.dart';
import 'package:humble_time_app/services/voice_service.dart';

class JournalReviewScreen extends StatefulWidget {
  const JournalReviewScreen({super.key});

  @override
  State<JournalReviewScreen> createState() => _JournalReviewScreenState();
}

class _JournalReviewScreenState extends State<JournalReviewScreen> {
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
    Future.microtask(() {
      if (mounted) {
        VoiceService.speakIfEnabled("Reviewing your journal entries.");
      }
    });
  }

  Future<void> _loadEntries() async {
    await JournalService().init(); // Hive init happens here
    final entries = JournalService().getAllEntries();
    setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal Review")),
      body: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Export"),
                onPressed: () {
                  // TODO: Add export logic
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Import"),
                onPressed: () {
                  // TODO: Add import logic
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.insights),
                label: const Text("History"),
                onPressed: () => context.go('/reflection-history'),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _entries.isEmpty
                ? const Center(child: Text("No journal entries found"))
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      final formattedDate = DateFormat.yMMMd().add_jm().format(entry.timestamp);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.reflection ?? '', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              Text("Mood: ${entry.moodLabel ?? 'Unknown'}", style: Theme.of(context).textTheme.bodyMedium),
                              Text("🕒 $formattedDate", style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}