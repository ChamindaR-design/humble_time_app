import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:humble_time_app/models/journal_entry.dart';

class JournalService {
  static const String _boxName = 'journal_entries';

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: true,
    ),
  );

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<JournalEntry>(_boxName);
    }
  }

  Box<JournalEntry> get _box => Hive.box<JournalEntry>(_boxName);

  Future<void> saveEntry(JournalEntry entry) async {
    await _box.add(entry);
  }

  Future<void> deleteEntry(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  List<JournalEntry> getAllEntries({bool sorted = true}) {
    final entries = _box.values.toList();
    if (sorted) {
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    return entries;
  }

  List<JournalEntry> filterByMood(String mood) {
    return getAllEntries().where((e) => e.moodLabel == mood).toList();
  }

  List<JournalEntry> filterByTag(String tag) {
    return getAllEntries().where((e) => e.blockTags?.contains(tag) ?? false).toList();
  }

  List<Map<String, dynamic>> exportToJson() {
    return getAllEntries(sorted: false).map((e) => e.toJson()).toList();
  }

  Future<void> restoreFromJson(List<Map<String, dynamic>> jsonList) async {
    await clearAll();
    for (final json in jsonList) {
      final entry = JournalEntry.fromJson(json);
      await saveEntry(entry);
    }
  }

  void logAllEntries() {
    if (!kDebugMode) return;

    for (var i = 0; i < _box.length; i++) {
      final entry = _box.getAt(i);
      _logger.d('[$i] ${entry?.timestamp} | Mood: ${entry?.moodLabel} | Tags: ${entry?.blockTags}');
    }
  }

  /// Dev-only dashboard hook for introspection and export diagnostics
  void debugJournalDump() {
    if (!kDebugMode) return;

    _logger.i('📒 Journal Dump Start');
    logAllEntries();

    final json = exportToJson();
    _logger.i('📤 Exported ${json.length} entries to JSON');
    _logger.t('🔍 Sample JSON: ${json.isNotEmpty ? json.first : 'No entries'}');
    _logger.i('📒 Journal Dump End');
  }
}
