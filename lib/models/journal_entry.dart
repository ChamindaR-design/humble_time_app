import 'package:hive/hive.dart';
import 'block_reflection.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 2)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final String? moodLabel;

  @HiveField(2)
  final String? reflection;

  @HiveField(3)
  final List<String>? blockTags;

  JournalEntry({
    required this.timestamp,
    this.moodLabel,
    this.reflection,
    this.blockTags,
  });

  JournalEntry copyWith({
    DateTime? timestamp,
    String? moodLabel,
    String? reflection,
    List<String>? blockTags,
  }) {
    return JournalEntry(
      timestamp: timestamp ?? this.timestamp,
      moodLabel: moodLabel ?? this.moodLabel,
      reflection: reflection ?? this.reflection,
      blockTags: blockTags ?? this.blockTags,
    );
  }

  factory JournalEntry.fromBlockReflection(BlockReflection reflection, String content) {
    return JournalEntry(
      timestamp: DateTime.now(),
      moodLabel: reflection.mood,
      reflection: content,
      blockTags: [reflection.label ?? ''],
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'moodLabel': moodLabel,
    'reflection': reflection,
    'blockTags': blockTags,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      timestamp: DateTime.parse(json['timestamp']),
      moodLabel: json['moodLabel'],
      reflection: json['reflection'],
      blockTags: (json['blockTags'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
