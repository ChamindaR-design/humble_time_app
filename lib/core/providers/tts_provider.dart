import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TTSService() {
    _tts.setLanguage('en-GB');       // Optional: British English
    _tts.setSpeechRate(0.4);         // Accessible rate
    _tts.setVolume(1.0);             // Max volume
    _tts.setPitch(1.0);              // Natural pitch
  }

  Future<void> speak(String message) async {
    if (message.isEmpty) return;
    await _tts.speak(message);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  // Optional: expose settings for advanced control
  FlutterTts get raw => _tts;
}

final ttsProvider = Provider<TTSService>((ref) => TTSService());

