import 'package:hive/hive.dart';

part 'block_reflection.g.dart';

@HiveType(typeId: 0)
class BlockReflection extends HiveObject {
  @HiveField(0)
  final int hour;

  @HiveField(1)
  final String? note;

  @HiveField(2)
  final String? mood;

  @HiveField(3)
  final String? label;

  @HiveField(4)
  final DateTime timestamp;

  BlockReflection({
    required this.hour,
    this.note,
    this.mood,
    this.label,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'Hour: $hour, Note: $note, Mood: $mood, Label: $label, Timestamp: $timestamp';
  }
}
