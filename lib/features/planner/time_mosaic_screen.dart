import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/services/session_logger.dart';
import 'package:humble_time_app/widgets/block_timer_overlay.dart';
// Optional: Uncomment if using vibration
import 'package:vibration/vibration.dart';
import 'package:humble_time_app/widgets/block_reflection_modal.dart';

import 'package:humble_time_app/models/block_reflection.dart';
import 'package:humble_time_app/services/hive_service.dart';

class TimeMosaicScreen extends StatefulWidget {
  const TimeMosaicScreen({super.key});

  @override
  State<TimeMosaicScreen> createState() => _TimeMosaicScreenState();
}

class _TimeMosaicScreenState extends State<TimeMosaicScreen> {
  final List<int> blocks = List.generate(24, (i) => i); // 24 hours
  int? _selectedHour;
  final Duration _focusDuration = const Duration(minutes: 25);
  Timer? _timer;
  int _secondsRemaining = 0;

  // 🧠 Milestone flags
  bool _hasAnnouncedHalfway = false;
  bool _hasAnnouncedComplete = false;

  @override
  void initState() {
    super.initState();
    VoiceService.speak(PromptLibrary.forEvent('welcomeBack'));
  }

  void onStartBlock(int hour) {
    setState(() {
      _selectedHour = hour;
      _secondsRemaining = _focusDuration.inSeconds;
      _hasAnnouncedHalfway = false;
      _hasAnnouncedComplete = false;
    });

    VoiceService.speak(PromptLibrary.forEvent('startBlock'));
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);

        final progress = timerProgress;

        if (!_hasAnnouncedHalfway && progress >= 0.5) {
          _hasAnnouncedHalfway = true;
          VoiceService.speak('You’re halfway through. Keep going!');
          // Optional haptic feedback
          final hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 100);
          }
        }
      } else {
        timer.cancel();
        if (!_hasAnnouncedComplete) {
          _hasAnnouncedComplete = true;
          VoiceService.speak('Focus block complete. Well done!');
          // Optional haptic feedback
          final hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 200);
          }
        }
        onCompleteBlock();
      }
    });

    debugPrint('Timer started for block: $hour:00');
  }

  void onCompleteBlock() {
    VoiceService.speak(PromptLibrary.forEvent('completeBlock'));
    if (_selectedHour != null) {
      SessionLogger.logBlock(_selectedHour!);
    }
    debugPrint('Block $_selectedHour completed.');
  }

  double get timerProgress {
    if (_selectedHour == null || _focusDuration.inSeconds == 0) return 0.0;
    return 1.0 - (_secondsRemaining / _focusDuration.inSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Mosaic'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 6,
        padding: const EdgeInsets.all(8),
        children: blocks.map((hour) {
          final isSelected = _selectedHour == hour;
          final timeDisplay = isSelected
              ? '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}'
              : '$hour:00';

          return GestureDetector(
            onTap: () {
              if (_selectedHour != hour || _secondsRemaining == 0) {
                /*showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlockReflectionModal(
                    hour: hour,
                    onSave: (note, mood, label) {
                      // (TODO): Save to Hive
                      debugPrint('Reflection saved for $hour:00 → $note, $mood, $label');
                    },
                  ),
                );*/
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlockReflectionModal(
                    hour: hour,
                    onSave: (note, mood, label) async {
                      final reflection = BlockReflection(
                        hour: hour,
                        note: note,
                        mood: mood,
                        label: label,
                      );
                      await HiveService.saveReflection(reflection);
                      debugPrint('Saved reflection: $reflection');
                    },
                  ),
                );
              } else {
                onStartBlock(hour);
              }
            },
            child: Semantics(
              label: isSelected
                  ? 'Block $hour selected. Timer running. ${timerProgress.toStringAsFixed(2)} progress.'
                  : 'Block $hour. Tap to start timer.',
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.tealAccent : Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: Colors.teal, width: 2)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      timeDisplay,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.grey.shade800,
                      ),
                    ),
                    if (isSelected)
                      BlockTimerOverlay(
                        progress: timerProgress,
                        isRunning: _secondsRemaining > 0,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/journal');
              break;
            case 2:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Mosaic',
          ),
        ],
      ),
    );
  }
}
