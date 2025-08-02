import 'package:flutter/material.dart';
import '../../services/voice_service.dart';
import '../../core/utils/ui_toolkit.dart';

class PacingScreen extends StatefulWidget {
  const PacingScreen({super.key});

  @override
  State<PacingScreen> createState() => _PacingScreenState();
}

class _PacingScreenState extends State<PacingScreen> with TickerProviderStateMixin {
  final UIToolkit toolkit = UIToolkit();

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  late AnimationController _timerController;
  int currentBlock = 0;
  int totalBlocks = 3;
  int blockDurationSeconds = 300;

  bool isRunning = false;
  bool affirmationsEnabled = true;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: blockDurationSeconds),
    );

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        VoiceService.speak("Block ${currentBlock + 1} completed.");
        setState(() => isRunning = false);

        if (affirmationsEnabled && currentBlock + 1 < totalBlocks) {
          VoiceService.speak("Pause. You're staying present.");
        }

        if (currentBlock + 1 < totalBlocks) {
          currentBlock++;
        } else {
          VoiceService.speak("All pacing blocks complete. Well done.");
          currentBlock = 0;
        }
      }
    });
  }

  void startBlock() {
    _timerController.forward(from: 0);
    setState(() => isRunning = true);
  }

  void stopBlock() {
    _timerController.stop();
    setState(() => isRunning = false);
  }

  void resetSession() {
    currentBlock = 0;
    setState(() => isRunning = false);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  String get timeRemaining {
    final seconds = (_timerController.duration!.inSeconds * (1 - _timerController.value)).round();
    return "${seconds ~/ 60}m ${seconds % 60}s remaining";
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = toolkit.scaledFontSize(context, 16);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacing Support')),
      body: Container(
        color: toolkit.softBackground(context),
        padding: toolkit.horizontalPadding(context, 2.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Gentle Pacing", style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Block ${currentBlock + 1} of $totalBlocks", style: TextStyle(fontSize: fontSize)),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, _) {
                return Center(
                  child: Transform.scale(
                    scale: _breathAnimation.value,
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade200,
                      ),
                      child: const Center(
                        child: Icon(Icons.self_improvement, size: 60, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(timeRemaining, style: TextStyle(fontSize: fontSize)),
            ),
            const SizedBox(height: 24),
            Center(
              child: isRunning
                  ? ElevatedButton(onPressed: stopBlock, child: Text("Pause", style: TextStyle(fontSize: fontSize)))
                  : ElevatedButton(onPressed: startBlock, child: Text("Start Block", style: TextStyle(fontSize: fontSize))),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: resetSession,
                child: Text("🔄 Reset Session", style: TextStyle(fontSize: fontSize - 1)),
              ),
            ),
            toolkit.verticalSpace(context, 2.0),
            SwitchListTile(
              title: Text("Voice Affirmations", style: TextStyle(fontSize: fontSize)),
              value: affirmationsEnabled,
              onChanged: (val) => setState(() => affirmationsEnabled = val),
            ),
          ],
        ),
      ),
    );
  }
}
