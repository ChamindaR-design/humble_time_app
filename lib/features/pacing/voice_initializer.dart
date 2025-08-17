import 'package:flutter/material.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';

/// VoiceInitializer fires a voice prompt once, immediately after the first frame has rendered.
/// This ensures TTS runs on the correct platform thread and avoids crashes in release builds.
class VoiceInitializer extends StatefulWidget {
  const VoiceInitializer({super.key});

  @override
  State<VoiceInitializer> createState() => _VoiceInitializerState();
}

class _VoiceInitializerState extends State<VoiceInitializer> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ Post-frame ensures we're fully on the platform thread
      await Future.delayed(const Duration(milliseconds: 500)); // extra safety delay

      if (!mounted) return;

      try {
        final locale = Localizations.localeOf(context);
        final prompt = await PromptLibrary.forEvent('startBlock', locale);

        // Only speak if voice is enabled and in a safe mode
        await VoiceService.speak(prompt);
      } catch (e) {
        debugPrint('VoiceInitializer: Failed to speak startup prompt — $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
