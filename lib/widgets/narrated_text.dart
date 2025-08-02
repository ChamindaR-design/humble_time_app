import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/core/utils/accessibility_toolkit.dart';

class NarratedText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool speakOnBuild;

  const NarratedText({
    super.key,
    required this.text,
    this.baseFontSize = 16,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.speakOnBuild = true,
  });

  Future<void> _speakText() async {
    final tts = FlutterTts();
    await tts.setLanguage("en-GB");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.45);
    await tts.setVolume(1.0);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final toolkit = AccessibilityToolkit(context);
    final scaledSize = toolkit.scaledFontSize(baseFontSize);

    if (speakOnBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _speakText();
      });
    }

    return Text(
      text,
      style: style?.copyWith(fontSize: scaledSize) ??
          TextStyle(fontSize: scaledSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
