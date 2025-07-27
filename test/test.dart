import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatelessWidget {
  final FlutterTts tts = FlutterTts();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => tts.speak("Testing Flutter TTS"),
          child: const Text("Test TTS"),
        ),
      ),
    );
  }
}
