import '../models/journal_entry.dart';

Map<String, int> getMoodSummary(List<JournalEntry> entries) {
  final summary = <String, int>{};
  for (var entry in entries) {
    if (entry.moodLabel != null) {
      summary.update(entry.moodLabel!, (count) => count + 1, ifAbsent: () => 1);
    }
  }
  return summary;
}

String getReflectionPreview(JournalEntry entry, {int maxLength = 80}) {
  final text = entry.reflection ?? '';
  return text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
}
