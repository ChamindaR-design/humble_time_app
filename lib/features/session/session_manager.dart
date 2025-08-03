import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/log/log_provider.dart';

final sessionManagerProvider = Provider((ref) {
  return SessionManager(ref);
});

class SessionManager {
  final Ref ref;

  SessionManager(this.ref);

  void completeSession({
    required DateTime start,
    required DateTime end,
    required LogBlockType type,
    bool usedVoice = false,
    String? note,
    List<String>? tags,
  }) {
    final entry = LogEntry(
      startTime: start,
      endTime: end,
      blockType: type,
      usedVoicePrompts: usedVoice,
      note: note,
      tags: tags,
    );

    ref.read(logListProvider.notifier).addLog(entry);
  }
}
