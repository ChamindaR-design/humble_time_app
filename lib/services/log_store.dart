import 'package:humble_time_app/models/log_entry.dart';

class LogStore {
  // Singleton instance
  static final LogStore instance = LogStore._internal();
  LogStore._internal();

  // Internal list of log entries
  final List<LogEntry> _entries = [];

  /// Save a log entry to the store
  Future<void> saveEntry(LogEntry entry) async {
    // Simulate async delay (e.g. for future database or cloud sync)
    await Future.delayed(const Duration(milliseconds: 100));
    _entries.add(entry);
  }

  /// Retrieve all saved entries
  List<LogEntry> get entries => List.unmodifiable(_entries);

  /// Clear all entries (optional utility)
  Future<void> clear() async {
    _entries.clear();
  }
}
