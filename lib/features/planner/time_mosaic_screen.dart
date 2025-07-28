import 'package:flutter/material.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';

class TimeMosaicScreen extends StatefulWidget {
  const TimeMosaicScreen({super.key});

  @override
  State<TimeMosaicScreen> createState() => _TimeMosaicScreenState();
}

class _TimeMosaicScreenState extends State<TimeMosaicScreen> {
  final voice = VoiceService();
  final List<int> blocks = List.generate(24, (i) => i); // 24 hours

  @override
  void initState() {
    super.initState();
    VoiceService.speak(PromptLibrary.forEvent('welcomeBack'));
  }

  void onStartBlock() {
    VoiceService.speak(PromptLibrary.forEvent('startBlock'));
  }

  void onCompleteBlock() {
    VoiceService.speak(PromptLibrary.forEvent('completeBlock'));
  }

  void onIdleDetected() {
    VoiceService.speak(PromptLibrary.forEvent('idleDetected'));
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Mosaic')),
      body: GridView.count(
        crossAxisCount: 6,
        padding: const EdgeInsets.all(8),
        children: blocks.map((hour) {
          return GestureDetector(
            onTap: () {
              onStartBlock(); // Hook into timer logic here if needed
              debugPrint('Block selected: $hour:00');
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('$hour:00'),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
