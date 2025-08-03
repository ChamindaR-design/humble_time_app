import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/log/log_tile.dart';

final logListProvider = Provider<List<LogEntry>>((ref) {
  return [
    LogEntry(
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      blockType: LogBlockType.focusBlock,
      usedVoicePrompts: true,
      note: "Morning sprint session",
      tags: ["energy", "creative"],
    ),
    LogEntry(
      startTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      endTime: DateTime.now().subtract(const Duration(hours: 1)),
      blockType: LogBlockType.breakBlock,
      usedVoicePrompts: false,
      note: "Nature walk",
    ),
  ];
});

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logEntries = ref.watch(logListProvider);

    return AppShell(
      child: Scaffold(
        appBar: AppBar(title: const Text('Log History')),
        body: logEntries.isEmpty
            ? const Center(
                child: Text(
                  'No logs yet.\nStart a session to begin tracking!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: logEntries.length,
                itemBuilder: (context, index) {
                  final entry = logEntries[index];
                  return LogTile(entry: entry);
                },
              ),
      ),
    );
  }
}
