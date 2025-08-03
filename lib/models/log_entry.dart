import 'package:hive/hive.dart';

part 'log_entry.g.dart';

@HiveType(typeId: 0)
enum LogBlockType {
  @HiveField(0)
  focusBlock,
  @HiveField(1)
  breakBlock,
  @HiveField(2)
  defaultBlock,
  @HiveField(3)
  meditation,
  @HiveField(4)
  other,
}

@HiveType(typeId: 1)
class LogEntry extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  DateTime endTime;

  @HiveField(2)
  LogBlockType blockType;

  @HiveField(3)
  bool usedVoicePrompts;

  @HiveField(4)
  String? note;

  @HiveField(5)
  List<String>? tags;

  @HiveField(6)
  String? mood;

  LogEntry({
    required this.startTime,
    required this.endTime,
    required this.blockType,
    this.usedVoicePrompts = false,
    this.note,
    this.tags,
    this.mood,
  });

  Duration get duration => endTime.difference(startTime);

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get readableType {
    switch (blockType) {
      case LogBlockType.focusBlock:
        return 'Focus';
      case LogBlockType.breakBlock:
        return 'Break';
      case LogBlockType.defaultBlock:
        return 'Default';
      case LogBlockType.meditation:
        return 'Meditation';
      case LogBlockType.other:
        return 'Other';
    }
  }

  LogEntry copyWith({
    DateTime? startTime,
    DateTime? endTime,
    LogBlockType? blockType,
    bool? usedVoicePrompts,
    String? note,
    List<String>? tags,
    String? mood,
  }) {
    return LogEntry(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      blockType: blockType ?? this.blockType,
      usedVoicePrompts: usedVoicePrompts ?? this.usedVoicePrompts,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
    );
  }
}
