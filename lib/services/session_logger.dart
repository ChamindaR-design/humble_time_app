import 'package:shared_preferences/shared_preferences.dart';

class SessionLogger {
  static const String _key = 'completedBlocks';

  /// Logs a completed block with timestamp
  static Future<void> logBlock(int hour) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    final timestamp = DateTime.now().toIso8601String();
    final entry = '$hour:$timestamp';

    existing.add(entry);
    await prefs.setStringList(_key, existing);
  }

  /// Retrieves all logged blocks
  static Future<List<String>> getLoggedBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Clears all logged blocks (optional for reset/debug)
  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
