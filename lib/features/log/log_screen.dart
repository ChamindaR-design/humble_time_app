import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/log/widgets/log_entry_card.dart';
import 'package:humble_time_app/features/log/services/log_voice_service.dart';

import 'package:humble_time_app/services/voice_service.dart';
import 'package:go_router/go_router.dart';

final logListProvider = Provider<List<LogEntry>>((ref) {
  return [
    LogEntry(
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      blockType: LogBlockType.focusBlock,
      usedVoicePrompts: true,
      note: "Morning sprint session",
      tags: ["energy", "creative"],
      mood: "Hopeful",
    ),
    LogEntry(
      startTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      endTime: DateTime.now().subtract(const Duration(hours: 1)),
      blockType: LogBlockType.breakBlock,
      usedVoicePrompts: false,
      note: "Nature walk",
      mood: "Calm",
    ),
  ];
});

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logEntries = ref.watch(logListProvider);
    final voiceService = LogVoiceService();

    return AppShell(
      child: Scaffold(
        /*appBar: AppBar(
          title: const Text('Log History'),
          automaticallyImplyLeading: true, // ✅ Back arrow
        ),*/
        appBar: AppBar(
          title: const Text('Log History'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back to Home',
            onPressed: () {
              HapticFeedback.selectionClick();
              VoiceService.speak("Returning to Home");
              context.go('/');
              //context.goNamed('home'); // Don't work usingh the AppShell
            },
          ),
        ),
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
                  return LogEntryCard(
                    title: entry.mood ?? entry.readableType,
                    subtitle: entry.note ?? 'No note added',
                    timestamp: entry.startTime,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      //Navigator.pushNamed(context, '/log/detail');
                      //context.push('/reflection', extra: entry);
                      //context.go('/reflection');
                      //context.pushNamed('reflection');
                      context.pushNamed('reflection', extra: entry);
                      //context.go('/reflection', extra: entry);
                    },
                    onPlayVoice: entry.usedVoicePrompts
                        ? () => voiceService.speakEntry(entry)
                        : null,
                  );
                },
              ),
      ),
    );
  }
}
