import 'dart:io'; // Platform checks
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice tone presets for different contexts
enum VoiceProfile { calm, upbeat, instructional }

class VoiceService {
  static final FlutterTts _tts = FlutterTts();

  /// Applies a predefined voice profile
  static Future<void> applyVoiceProfile(VoiceProfile profile) async {
    _currentProfile = profile;
    switch (profile) {
      case VoiceProfile.calm:
        await updateVoiceSettings(pitch: 0.9, rate: 0.4);
        break;
      case VoiceProfile.upbeat:
        await updateVoiceSettings(pitch: 1.2, rate: 0.5);
        break;
      case VoiceProfile.instructional:
        await updateVoiceSettings(pitch: 1.0, rate: 0.6);
        break;
    }

    _log('VoiceService: Applied voice profile "$profile"');
  }

  /// Whether voice prompts are enabled (can be toggled via settings screen)
  static bool isVoiceEnabled = true;

  /// Optional: toggle debug logging
  static bool enableLogging = kDebugMode;

  /// Internal flag to prevent overlapping speech
  static bool _isSpeaking = false;

  /// Timestamp for debounce logic
  static DateTime _lastSpokenAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Initializes TTS with default voice settings + fallback
  static Future<void> init() async {
    try {
      final availableLanguages = await _tts.getLanguages ?? [];
      final preferredLanguage = availableLanguages.contains("en-GB")
          ? "en-GB"
          : "en-US"; // 🌐 Fallback if needed

      await _tts.setLanguage(preferredLanguage);
      await _tts.setPitch(1.0);              // Moderate tone
      await _tts.setSpeechRate(0.4);         // Calm pacing
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true); // 🔊 Full delivery before reset
      await applyVoiceProfile(VoiceProfile.calm);

      _log('VoiceService: Initialized with language "$preferredLanguage"');
    } catch (e) {
      _log('VoiceService: Failed to initialize — $e');
    }
  }

  /// Speaks text if enabled, with overlap + platform safeguards
  static Future<void> speak(String text) async {
    if (!isVoiceEnabled || _isSpeaking || text.trim().isEmpty) return;

/*    // 🧯 Windows debug mode protection
    if (Platform.isWindows && kDebugMode) {
      _log('VoiceService: Skipping TTS in Windows debug mode');
      return;
    }*/

   // 🧯 Safe Windows debug mode protection
    if (!kIsWeb && Platform.isWindows && kDebugMode) {
      _log('VoiceService: Skipping TTS in Windows debug mode');
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastSpokenAt) < const Duration(milliseconds: 500)) {
      _log('VoiceService: Skipped due to debounce');
      return;
    }
    _lastSpokenAt = now;

    _log('VoiceService: Speaking — "$text"');

    try {
      _isSpeaking = true;
      await _tts.stop(); // Clear buffered speech
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(text);
      await Future.delayed(const Duration(milliseconds: 300)); // Optional buffer
    } catch (e) {
      _log('VoiceService: Failed to speak — $e');
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

  /// Resets internal state (e.g., on route change or app pause)
  static void reset() {
    _isSpeaking = false;
    _lastSpokenAt = DateTime.fromMillisecondsSinceEpoch(0);
    _log('VoiceService: Reset state');
  }

  /// Whether TTS is currently speaking
  static bool get isSpeaking => _isSpeaking;

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

    _log('VoiceService: Updated voice settings');
  }

  /// Updates TTS language based on app locale
  /*static Future<void> updateLanguageFromLocale(Locale locale) async {
    final langCode = switch (locale.languageCode) {
      'si' => 'si-LK', // Sinhala
      'ja' => 'ja-JP', // Japanese
      'en' => 'en-GB', // or 'en-US' based on preference
      _ => 'en-US',    // fallback
    };

    try {
      await _tts.setLanguage(langCode);
      _log('VoiceService: Language updated to "$langCode"');
    } catch (e) {
      _log('VoiceService: Failed to update language — $e');
    }
  }*/
  
  static VoiceProfile? _currentProfile;
  
  static Future<void> updateLanguageFromLocale(Locale locale) async {
    final requestedLang = switch (locale.languageCode) {
      'si' => 'si-LK',
      'ja' => 'ja-JP',
      'en' => 'en-GB',
      _ => 'en-US',
    };

    try {
      final voices = await _tts.getLanguages ?? [];
      _log('Available TTS languages: ${voices.join(', ')}');

      final fallbackLang = voices.contains(requestedLang)
          ? requestedLang
          : (voices.contains('en-US') ? 'en-US' : voices.first);

      await _tts.setLanguage(fallbackLang);
      _log('VoiceService: Language updated to "$fallbackLang"');

      if (requestedLang != fallbackLang) {
        await speak('Voice not available in your language. Using fallback.');
      }
    } catch (e) {
      _log('VoiceService: Failed to update language — $e');
    }
  }

  static VoiceProfile? get currentProfile => _currentProfile;

  /// Optional: expose instance for advanced use
  static FlutterTts get instance => _tts;

  /// Internal logging helper
  static void _log(String message) {
    if (enableLogging) debugPrint(message);
  }

}
