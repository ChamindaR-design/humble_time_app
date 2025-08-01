import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier();
});

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([]);

  void addEntry(JournalEntry entry) {
    state = [...state, entry];
  }

  void updateEntry(int index, JournalEntry updated) {
    if (index >= 0 && index < state.length) {
      final newState = [...state];
      newState[index] = updated;
      state = newState;
    }
  }

  void deleteEntry(int index) {
    if (index >= 0 && index < state.length) {
      final newState = [...state]..removeAt(index);
      state = newState;
    }
  }

  void clearJournal() {
    state = [];
  }

  List<JournalEntry> filterByMood(String mood) {
    return state.where((e) => e.moodLabel == mood).toList();
  }

  List<JournalEntry> entriesBetween(DateTime start, DateTime end) {
    return state.where((e) => e.timestamp.isAfter(start) && e.timestamp.isBefore(end)).toList();
  }
}
