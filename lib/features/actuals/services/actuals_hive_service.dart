import 'dart:convert';
import 'dart:developer' as dev;
import 'package:hive/hive.dart';
import 'package:humble_time_app/models/actuals_entry.dart';

class ActualsHiveService {
  static const String boxName = 'actualsEntries';

  /// Initializes Hive and registers adapter
  static Future<void> init() async {
    //Hive.registerAdapter(ActualsEntryAdapter());
    await Hive.openBox<ActualsEntry>(boxName);
  }

  /// Opens the actuals box for direct access
  static Future<Box<ActualsEntry>> getBox() async {
    return Hive.openBox<ActualsEntry>(boxName);
  }

  /// Saves an actuals entry
  static Future<void> saveEntry(ActualsEntry entry) async {
    final box = Hive.box<ActualsEntry>(boxName);
    await box.add(entry);
  }

  /// Retrieves all saved actuals, sorted by timestamp
  static List<ActualsEntry> getAllEntries() {
    final box = Hive.box<ActualsEntry>(boxName);
    final entries = box.values.toList();
    entries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return entries;
  }

  /// Deletes an entry by index
  static Future<void> deleteEntry(int index) async {
    final box = Hive.box<ActualsEntry>(boxName);
    await box.deleteAt(index);
  }

  /// Clears all actuals entries
  static Future<void> clearAll() async {
    final box = Hive.box<ActualsEntry>(boxName);
    await box.clear();
  }

  /// Exports all actuals to a formatted JSON string
  static Future<String> exportToJson() async {
    final box = Hive.box<ActualsEntry>(boxName);
    final entries = box.values.map((e) => {
      'text': e.text,
      'createdAt': e.createdAt.toIso8601String(),
    }).toList();

    final export = {
      'version': 1,
      'data': entries,
    };

    return const JsonEncoder.withIndent('  ').convert(export);
  }

  /// Restores actuals from a JSON string
  static Future<void> restoreFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> parsed = jsonDecode(jsonString);
      final List<dynamic> data = parsed['data'] ?? [];
      final box = Hive.box<ActualsEntry>(boxName);

      for (final entry in data) {
        final restored = ActualsEntry(
          text: entry['text'] ?? '',
          createdAt: DateTime.parse(entry['createdAt']),
        );
        await box.add(restored);
      }
    } catch (e) {
      dev.log('❌ Failed to restore actuals: $e', name: 'ActualsHiveService');
    }
  }
}
