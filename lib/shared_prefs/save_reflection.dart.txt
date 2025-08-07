import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class Reflection {
  final String timestamp;
  final int block;
  final String intention;
  final String breathingStyle;
  final String note;

  Reflection({
    required this.timestamp,
    required this.block,
    required this.intention,
    required this.breathingStyle,
    required this.note,
  });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      timestamp: json['timestamp'] ?? '',
      block: json['block'] ?? 0,
      intention: json['intention'] ?? '',
      breathingStyle: json['breathingStyle'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'block': block,
    'intention': intention,
    'breathingStyle': breathingStyle,
    'note': note,
  };

  @override
  String toString() =>
      "$timestamp | Block $block | $intention | $breathingStyle | $note";
}

Future<void> saveReflection({
  required int currentBlock,
  required String intention,
  required String breathingStyle,
  String note = "Session ended smoothly.",
}) async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(now);

  final reflection = Reflection(
    timestamp: timestamp,
    block: currentBlock,
    intention: intention,
    breathingStyle: breathingStyle,
    note: note.isEmpty ? "Session ended smoothly." : note,
  );

  final jsonString = jsonEncode(reflection.toJson());

  await prefs.setString("reflection_$timestamp", jsonString); // Historical log
  await prefs.setString("latest_reflection", jsonString);     // Latest for summary

  log.i("✅ Saved reflection → reflection_$timestamp");
}

Future<Reflection?> loadLatestReflection() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString("latest_reflection");
  if (data == null) return null;

  try {
    final map = jsonDecode(data);
    return Reflection.fromJson(map);
  } catch (e) {
    log.w("⚠️ Failed to parse latest reflection: $e");
    return null;
  }
}

Future<List<Reflection>> loadAllReflections() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys().where((k) => k.startsWith("reflection_")).toList();

  final reflections = <Reflection>[];

  for (final key in keys) {
    final data = prefs.getString(key);
    if (data == null) continue;

    try {
      final map = jsonDecode(data);
      final reflection = Reflection.fromJson(map);
      reflections.add(reflection);
    } catch (e) {
      log.w("⚠️ Failed to parse reflection for key $key: $e");
    }
  }

  // Sort by timestamp descending
  reflections.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  return reflections;
}
