import 'dart:io'; // 👈 Platform checks
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final FlutterTts _tts = FlutterTts();

  /// Whether voice prompts are enabled (can be toggled via settings screen)
  static bool isVoiceEnabled = true;

  /// Internal flag to prevent overlapping speech
  static bool _isSpeaking = false;

  /// Initializes TTS with default voice settings + fallback
  static Future<void> init() async {
    final availableLanguages = await _tts.getLanguages;
    final preferredLanguage = availableLanguages.contains("en-GB")
        ? "en-GB"
        : "en-US"; // 🌐 Fallback if needed

    await _tts.setLanguage(preferredLanguage);
    await _tts.setPitch(1.0);              // Moderate tone
    await _tts.setSpeechRate(0.4);         // Calm pacing
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true); // 🔊 Full delivery before reset
  }

  /// Speaks text if enabled, with overlap + platform safeguards
  static Future<void> speak(String text) async {
    if (!isVoiceEnabled || _isSpeaking || text.trim().isEmpty) return;

    // 🧯 Windows debug mode protection
    if (Platform.isWindows && kDebugMode) {
      debugPrint('VoiceService: Skipping TTS in Windows debug mode');
      return;
    }

    debugPrint('VoiceService: Speaking — "$text"');

    try {
      _isSpeaking = true;
      await _tts.stop(); // Clear buffered speech
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(text);
      await Future.delayed(const Duration(milliseconds: 300)); // Optional buffer
    } catch (e) {
      debugPrint('VoiceService: Failed to speak — $e');
    } finally {
      _isSpeaking = false;
    }
  }

  /// Shortcut for conditional speech
  static Future<void> speakIfEnabled(String text) async {
    if (isVoiceEnabled) await speak(text);
  }

  /// Stops current speech immediately
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

  /// Optional: expose instance for advanced use
  static FlutterTts get instance => _tts;
}
