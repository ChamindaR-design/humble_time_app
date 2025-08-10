class JournalEntry {
  final DateTime timestamp;
  final String? moodLabel;
  final String? reflection;
  final List<String>? blockTags;

  const JournalEntry({
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
}
