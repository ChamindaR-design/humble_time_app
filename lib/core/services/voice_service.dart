import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> init() async {
    await _flutterTts.setLanguage("en-GB");
    await _flutterTts.setPitch(1.0);     // Moderate tone
    await _flutterTts.setSpeechRate(0.4); // Calm pacing
    await _flutterTts.setVolume(1.0);
  }

  static Future<void> speak(String text) async {
    await _flutterTts.stop(); // Stop any ongoing speech
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  static Future<void> updateVoiceSettings({
    double? pitch,
    double? rate,
    String? language,
  }) async {
    if (pitch != null) await _flutterTts.setPitch(pitch);
    if (rate != null) await _flutterTts.setSpeechRate(rate);
    if (language != null) await _flutterTts.setLanguage(language);
  }
}
