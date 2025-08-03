import 'package:humble_time_app/models/log_entry.dart';

class Session {
  final DateTime startTime;
  final DateTime? endTime; // may be null until session completes
  final LogBlockType blockType;
  final bool usedVoicePrompts;
  final String? note;
  final List<String>? tags;

  Session({
    required this.startTime,
    required this.blockType,
    this.endTime,
    this.usedVoicePrompts = false,
    this.note,
    this.tags,
  });

  bool get isActive => endTime == null;

  LogEntry toLogEntry({String? overrideNote, List<String>? overrideTags}) {
    if (endTime == null) throw Exception("Session is not yet complete.");
    return LogEntry(
      startTime: startTime,
      endTime: endTime!,
      blockType: blockType,
      usedVoicePrompts: usedVoicePrompts,
      note: overrideNote ?? note,
      tags: overrideTags ?? tags ?? [],
    );
  }
}
