import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/block_reflection.dart';
import 'dart:developer' as dev;

class HiveService {
  static const String boxName = 'block_reflections';

  /// Initializes Hive and registers adapter
  static Future<void> init() async {
    Hive.registerAdapter(BlockReflectionAdapter());
    await Hive.openBox<BlockReflection>(boxName);
  }

  /// Saves a reflection using a composite timestamp key
  static Future<void> saveReflection(BlockReflection reflection) async {
    final box = Hive.box<BlockReflection>(boxName);
    final key = reflection.timestamp.toIso8601String(); // Unique per entry
    await box.put(key, reflection);
  }

  /// Retrieves all saved reflections, sorted by timestamp
  static List<BlockReflection> getAllReflections() {
    final box = Hive.box<BlockReflection>(boxName);
    final reflections = box.values.toList();
    reflections.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return reflections;
  }

  /// Retrieves a reflection for a specific hour
  static BlockReflection? getReflectionForHour(int hour) {
    final box = Hive.box<BlockReflection>(boxName);
    final matches = box.values.where((r) => r.hour == hour);
    return matches.isNotEmpty ? matches.first : null;
  }

  /// Deletes a reflection by key
  static Future<void> deleteReflection(String key) async {
    final box = Hive.box<BlockReflection>(boxName);
    await box.delete(key);
  }

  /// Clears all reflections
  static Future<void> clearAllReflections() async {
    final box = Hive.box<BlockReflection>(boxName);
    await box.clear();
  }

  /// Exports all reflections to a formatted JSON string with versioning
  static Future<String> exportToJson() async {
    final box = Hive.box<BlockReflection>(boxName);
    final reflections = box.values.map((r) => {
      'timestamp': r.timestamp.toIso8601String(),
      'hour': r.hour,
      'mood': r.mood,
      'note': r.note,
      'label': r.label,
    }).toList();

    final export = {
      'version': 1,
      'data': reflections,
    };

    return const JsonEncoder.withIndent('  ').convert(export);
  }

  /// Restores reflections from a JSON string with error handling
  static Future<void> restoreFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> parsed = jsonDecode(jsonString);
      final List<dynamic> data = parsed['data'] ?? [];
      final box = Hive.box<BlockReflection>(boxName);

      for (final entry in data) {
        final reflection = BlockReflection(
          timestamp: DateTime.parse(entry['timestamp']),
          hour: entry['hour'],
          mood: entry['mood'],
          note: entry['note'],
          label: entry['label'],
        );
        final key = reflection.timestamp.toIso8601String();
        await box.put(key, reflection);
      }
    } catch (e) {
      //print('❌ Failed to restore reflections: $e');
      dev.log('❌ Failed to restore reflections: $e', name: 'HiveService');
      // Optionally rethrow or show a user-friendly message
    }
  }
}
