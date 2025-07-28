import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final FlutterTts _tts = FlutterTts();

  /// Whether voice prompts are enabled (can be toggled via settings screen)
  static bool isVoiceEnabled = true;

  /// Internal flag to prevent overlapping speech
  static bool _isSpeaking = false;

  /// Initializes TTS with default voice settings
  static Future<void> init() async {
    await _tts.setLanguage("en-GB");
    await _tts.setPitch(1.0);          // Moderate tone
    await _tts.setSpeechRate(0.4);     // Calm pacing
    await _tts.setVolume(1.0);
  }

  /// Speaks text if enabled, with overlap protection
  static Future<void> speak(String text) async {
    if (!isVoiceEnabled || _isSpeaking || text.trim().isEmpty) return;

    _isSpeaking = true;
    await _tts.stop();                 // Ensure clean transition
    await _tts.speak(text);
    _isSpeaking = false;
  }

  /// Shortcut for conditional speech
  static Future<void> speakIfEnabled(String text) async {
    if (isVoiceEnabled) await speak(text);
  }

  /// Stops current speech
  static Future<void> stop() async => await _tts.stop();

  /// Update voice characteristics live
  static Future<void> updateVoiceSettings({
    double? pitch,
    double? rate,
    String? language,
    double? volume,
  }) async {
    if (pitch != null) await _tts.setPitch(pitch);
    if (rate != null) await _tts.setSpeechRate(rate);
    if (language != null) await _tts.setLanguage(language);
    if (volume != null) await _tts.setVolume(volume);
  }
}
