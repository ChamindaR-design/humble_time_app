import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.setLanguage("en-GB"); // 🇬🇧 Adjust for localization
    await _tts.setSpeechRate(0.5);   // Accessibility-friendly pacing
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }

  Future<void> stop() async => await _tts.stop();
}
