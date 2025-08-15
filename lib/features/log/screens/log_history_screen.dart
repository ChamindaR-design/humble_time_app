import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/services/voice_service.dart';

class LogHistoryScreen extends StatelessWidget {
  const LogHistoryScreen({super.key});

  void _speakEntry(LogEntry entry) {
    final textToSpeak = (entry.note?.trim().isNotEmpty ?? false)
        ? entry.note!
        : 'No reflection added.';

    VoiceService.speakIfEnabled(textToSpeak);
  }

  @override
  Widget build(BuildContext context) {
    final logBoxListenable = Hive.box<LogEntry>('logEntries').listenable();

    return AppShell(
      child: Scaffold(
        appBar: AppBar(title: const Text('Session History')),
        body: ValueListenableBuilder<Box<LogEntry>>(
          valueListenable: logBoxListenable,
          builder: (context, box, _) {
            final entries = box.values.toList().reversed.toList();

            if (entries.isEmpty) {
              return const Center(child: Text('No entries logged yet.'));
            }

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (_, index) {
                final entry = entries[index];

                return Semantics(
                  label: 'Session: ${entry.readableType}, duration: ${entry.formattedDuration}, mood: ${entry.mood ?? "not recorded"}',
                  button: true,
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('${entry.readableType} Entry'),
                          content: Text(
                            entry.note?.trim().isNotEmpty == true
                                ? entry.note!
                                : 'No reflection added.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                      _speakEntry(entry);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('${entry.readableType} — ${entry.formattedDuration}'),
                        subtitle: Text(entry.mood ?? 'No mood recorded'),
                        trailing: const Icon(Icons.volume_up),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
