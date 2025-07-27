import 'package:flutter_tts/flutter_tts.dart';

class VoiceConfig {
  final bool isEnabled;
  final String language;
  final double rate;
  final double pitch;
  final double volume;
  final String? voiceName;

  const VoiceConfig({
    this.isEnabled = true,
    this.language = "en-GB",
    this.rate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.voiceName,
  });

  /// Applies this config to a FlutterTts instance.
  Future<void> applyTo(FlutterTts tts) async {
    await tts.setLanguage(language);
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);
    await tts.setVolume(volume);
    
    if (voiceName != null) {
      await tts.setVoice({"name": voiceName!});
    }
  }
}
