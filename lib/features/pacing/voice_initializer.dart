import 'package:flutter/material.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';

/// VoiceInitializer fires a voice prompt once, immediately after the widget tree has built.
/// This avoids triggering TTS during VM-sensitive stages like app boot.
class VoiceInitializer extends StatefulWidget {
  const VoiceInitializer({super.key});

  @override
  State<VoiceInitializer> createState() => _VoiceInitializerState();
}

class _VoiceInitializerState extends State<VoiceInitializer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      VoiceService.speak(PromptLibrary.forEvent('startBlock'));
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
