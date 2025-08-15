import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/models/log_entry.dart';

class LogVoiceService {
  final FlutterTts _tts = FlutterTts();

  LogVoiceService() {
    _configureTts();
  }

  void _configureTts() {
    _tts.setLanguage('en-GB'); // You can localize this later
    _tts.setSpeechRate(0.5);   // Calm pacing
    _tts.setPitch(1.0);        // Neutral tone
    _tts.setVolume(1.0);       // Full volume
  }

  Future<void> speakEntry(LogEntry entry) async {
    final mood = entry.mood ?? entry.readableType;
    final note = entry.note ?? 'No note added';
    final duration = entry.formattedDuration;

    final prompt = _buildPrompt(mood, note, duration);

    await _tts.speak(prompt);
  }

  String _buildPrompt(String mood, String note, String duration) {
    final tonePrefix = _tonePrefixForMood(mood);
    return '$tonePrefix Reflection: $mood. Note: $note. Duration: $duration.';
  }

  String _tonePrefixForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'hopeful':
        return '🌤️ Here’s a bright moment.';
      case 'calm':
        return '🌿 A peaceful reflection.';
      case 'anxious':
        return '🌧️ A moment to process.';
      case 'energized':
        return '⚡ A high-energy insight.';
      case 'reflective':
        return '🪞 A thoughtful pause.';
      default:
        return '📝';
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
