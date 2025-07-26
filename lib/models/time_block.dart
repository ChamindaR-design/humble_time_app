//import 'package:flutter/foundation.dart';

enum TaskType { focusBlock, breakBlock }

class TimeBlock {
  final String label;
  final Duration duration;
  final bool isBreak;

  const TimeBlock({
    required this.label,
    required this.duration,
    required this.isBreak,
  });

  TaskType get taskType =>
      isBreak ? TaskType.breakBlock : TaskType.focusBlock;

  // Optional: for easier logging or debugging
  @override
  String toString() {
    return 'TimeBlock(label: $label, duration: ${duration.inMinutes} mins, type: ${taskType.name})';
  }

  // Optional: Equality helpers (if needed for comparing blocks)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeBlock &&
          label == other.label &&
          duration == other.duration &&
          isBreak == other.isBreak;

  @override
  int get hashCode =>
      label.hashCode ^ duration.hashCode ^ isBreak.hashCode;
}
