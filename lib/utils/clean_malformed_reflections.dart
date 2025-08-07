import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> cleanMalformedReflections() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys().where((k) => k.startsWith('reflection_'));

  for (final key in keys) {
    final raw = prefs.getString(key);
    if (raw == null) continue;

    try {
      jsonDecode(raw); // Try parsing
    } catch (_) {
      await prefs.remove(key);
      debugPrint('🧹 Removed malformed reflection: $key');
    }
  }

  debugPrint('✅ Reflection cleanup complete.');
}
