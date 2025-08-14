import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';

class VoicePromptPreview extends StatefulWidget {
  const VoicePromptPreview({super.key});

  @override
  State<VoicePromptPreview> createState() => _VoicePromptPreviewState();
}

class _VoicePromptPreviewState extends State<VoicePromptPreview> {
  final List<String> keys = [
    'startBlock',
    'completeBlock',
    'idleDetected',
    'moodPrompt',
    'moodSaved',
    'moodSelected',
    'welcomeBack',
    'leavingSession',
    'unknown',
  ];

  final FlutterTts tts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context); // ✅ Extract Locale

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];

        return FutureBuilder<String>(
          future: PromptLibrary.forEvent(key, locale, param: 'සතුටු'), // ✅ Await prompt
          builder: (context, snapshot) {
            final prompt = snapshot.data ?? '...';

            return ListTile(
              title: Text(prompt),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: snapshot.hasData
                    ? () => tts.speak(prompt)
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
