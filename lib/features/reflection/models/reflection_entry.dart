class ReflectionEntry {
  final String id;
  final DateTime timestamp;
  final String? mood;
  final String? note;

  ReflectionEntry({
    required this.id,
    required this.timestamp,
    this.mood,
    this.note,
  });

  ReflectionEntry copyWith({
    String? mood,
    String? note,
  }) {
    return ReflectionEntry(
      id: id,
      timestamp: timestamp,
      mood: mood ?? this.mood,
      note: note ?? this.note,
    );
  }
}
