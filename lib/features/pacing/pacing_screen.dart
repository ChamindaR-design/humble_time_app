import 'package:flutter/material.dart';
import '../../services/voice_service.dart';
import '../../core/utils/ui_toolkit.dart';
import '../../widgets/session/session_features.dart';

enum IntentionType { calm, clarity, focus, kindness }
enum BreathingStyle { box, fourSevenEight, custom }

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

  IntentionType selectedIntention = IntentionType.calm;
  BreathingStyle selectedBreathing = BreathingStyle.box;

  @override
  void initState() {
    super.initState();
    _setupBreathController();
    _setupTimerController();
    VoiceService.speak("What would you like to cultivate today?");
  }

  void _setupBreathController() {
    _breathController = AnimationController(
      vsync: this,
      duration: _getBreathDuration(),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  Duration _getBreathDuration() {
    switch (selectedBreathing) {
      case BreathingStyle.fourSevenEight:
        return const Duration(seconds: 8); // Longer out breath
      case BreathingStyle.box:
        return const Duration(seconds: 4);
      case BreathingStyle.custom:
      //default:
        return const Duration(seconds: 5);
    }
  }

  void _setupTimerController() {
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: blockDurationSeconds),
    );

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        VoiceService.speak("Block ${currentBlock + 1} completed.");
        setState(() => isRunning = false);

        if (affirmationsEnabled && currentBlock + 1 < totalBlocks) {
          VoiceService.speak(_getAffirmationForIntention());
        }

        if (currentBlock + 1 < totalBlocks) {
          setState(() => currentBlock++);
        } else {
          VoiceService.speak("All pacing blocks complete. Well done.");
          Future.delayed(const Duration(milliseconds: 700), () {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SessionEndScreen(completedBlocks: totalBlocks),
              ),
            );
            setState(() => currentBlock = 0);
          });
        }
      }
    });
  }

  String _getAffirmationForIntention() {
    switch (selectedIntention) {
      case IntentionType.focus: return "Stay present. You’re making progress.";
      case IntentionType.kindness: return "Be gentle. You're doing enough.";
      case IntentionType.clarity: return "Let thoughts settle. Clarity comes.";
      case IntentionType.calm:  return "Enjoy this moment. Just breathe.";
      //default: return "Enjoy this moment. Just breathe.";
    }
  }

  Color getThemeColor() {
    switch (selectedIntention) {
      case IntentionType.focus: return Colors.deepPurpleAccent;
      case IntentionType.kindness: return Colors.pinkAccent;
      case IntentionType.clarity: return Colors.teal;
      case IntentionType.calm: return Colors.indigo.shade200;
      //default: return Colors.indigo.shade200;
    }
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
    _timerController.reset();
    setState(() => isRunning = false);
  }

  void updateBreathingStyle(BreathingStyle style) {
    setState(() {
      selectedBreathing = style;
      _breathController.dispose();
      _setupBreathController();
    });
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
            DropdownButton<int>(
              value: blockDurationSeconds,
              items: [180, 300, 600, 900, 1500].map((sec) {
                return DropdownMenuItem(
                  value: sec,
                  child: Text("${(sec / 60).round()} min"),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    blockDurationSeconds = val;
                    _timerController.duration = Duration(seconds: val);
                  });
                }
              },
            ),
            Text("Intention", style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold)),
            DropdownButton<IntentionType>(
              value: selectedIntention,
              items: IntentionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedIntention = val!),
            ),
            const SizedBox(height: 8),
            Text("Breathing Style", style: TextStyle(fontSize: fontSize)),
            DropdownButton<BreathingStyle>(
              value: selectedBreathing,
              items: BreathingStyle.values.map((b) {
                return DropdownMenuItem(
                  value: b,
                  child: Text(b.name.replaceAll("_", " ").toUpperCase()),
                );
              }).toList(),
              onChanged: (val) => updateBreathingStyle(val!),
            ),
            const SizedBox(height: 16),
            Text("Block ${currentBlock + 1} of $totalBlocks", style: TextStyle(fontSize: fontSize)),
            LinearProgressIndicator(value: (currentBlock + 1) / totalBlocks),
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
                        color: getThemeColor(),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentBlock > 0
                      ? () => setState(() => currentBlock--)
                      : null,
                ),
                isRunning
                    ? ElevatedButton(onPressed: stopBlock, child: Text("Pause", style: TextStyle(fontSize: fontSize)))
                    : ElevatedButton(onPressed: startBlock, child: Text("Start", style: TextStyle(fontSize: fontSize))),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentBlock < totalBlocks - 1
                      ? () => setState(() => currentBlock++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
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

class SessionEndScreen extends StatelessWidget {
  final int completedBlocks;

  const SessionEndScreen({super.key, required this.completedBlocks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SessionFeatures(
          currentBlock: completedBlocks,
          totalBlocks: completedBlocks,
        ),
      ),
    );
  }
}
