import 'dart:io'; // Platform checks
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice tone presets for different contexts
enum VoiceProfile { calm, upbeat, instructional }

class VoiceService {
  static final FlutterTts _tts = FlutterTts();

  static VoiceProfile? _currentProfile;
  static bool isVoiceEnabled = true;
  static bool enableLogging = kDebugMode;
  static bool _isSpeaking = false;
  static DateTime _lastSpokenAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Initializes TTS with default voice settings
  static Future<void> init() async {
    try {
      final availableLanguages = await _tts.getLanguages ?? [];
      final preferredLanguage =
          availableLanguages.contains("en-GB") ? "en-GB" : "en-US";

      await _tts.setLanguage(preferredLanguage);
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      await applyVoiceProfile(VoiceProfile.calm);

      _log('VoiceService: Initialized with language "$preferredLanguage"');
    } catch (e) {
      _log('VoiceService: Failed to initialize — $e');
    }
  }

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

  /// Speaks text if enabled, with debounce and platform safeguards
  static Future<void> speak(String text) async {
    if (!isVoiceEnabled || _isSpeaking || text.trim().isEmpty) return;

    // 🧯 Skip TTS in Windows debug mode
    if (!kIsWeb && Platform.isWindows && kDebugMode) {
      _log('VoiceService: Skipping TTS in Windows debug mode');
      return;
    }

    // Optional: skip very first run in Windows release mode
    if (!kIsWeb && Platform.isWindows && kReleaseMode && _lastSpokenAt.millisecondsSinceEpoch == 0) {
      _log('VoiceService: Skipping very first TTS in Windows release mode');
      _lastSpokenAt = DateTime.now();
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
      await _tts.stop();
      await _tts.awaitSpeakCompletion(true);

      // 🧯 Windows threading workaround: allow extra time
      if (Platform.isWindows) {
        await Future.delayed(const Duration(milliseconds: 250));
      }

      await _tts.speak(text);
      await Future.delayed(const Duration(milliseconds: 300));
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

  /// Resets internal state
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
    try {
      if (pitch != null) await _tts.setPitch(pitch);
      if (rate != null) await _tts.setSpeechRate(rate);
      if (language != null) await _tts.setLanguage(language);
      if (volume != null) await _tts.setVolume(volume);

      _log('VoiceService: Updated voice settings');
    } catch (e) {
      _log('VoiceService: Failed to update voice settings — $e');
    }
  }

  /// Updates TTS language based on app locale
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
          : (voices.contains('en-US')
              ? 'en-US'
              : voices.contains('eng')
                  ? 'eng'
                  : voices.first);

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
  static FlutterTts get instance => _tts;

  static void _log(String message) {
    if (enableLogging) debugPrint(message);
  }
}
