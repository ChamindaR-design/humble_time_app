import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/models/log_entry.dart';

final logListProvider = StateNotifierProvider<LogListNotifier, List<LogEntry>>((ref) {
  return LogListNotifier();
});

class LogListNotifier extends StateNotifier<List<LogEntry>> {
  LogListNotifier() : super([]);

  void addLog(LogEntry entry) {
    state = [...state, entry];
  }

  void removeLog(int index) {
    state = [...state..removeAt(index)];
  }

  void clearLogs() {
    state = [];
  }
}
