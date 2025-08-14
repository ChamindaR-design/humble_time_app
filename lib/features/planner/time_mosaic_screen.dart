import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/services/session_logger.dart';
import 'package:humble_time_app/widgets/block_timer_overlay.dart';
import 'package:vibration/vibration.dart';
import 'package:humble_time_app/widgets/block_reflection_modal.dart';
import 'package:humble_time_app/models/block_reflection.dart';
import 'package:humble_time_app/services/hive_service.dart';

enum BlockStatus { completed, idle, skipped }

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

  bool _hasAnnouncedHalfway = false;
  bool _hasAnnouncedComplete = false;

  List<BlockReflection> _reflections = [];

  @override
  void initState() {
    super.initState();
    _initializeVoice();
    loadReflections();
  }

  Future<void> _initializeVoice() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    final prompt = await PromptLibrary.forEvent('welcomeBack', locale);
    await VoiceService.speak(prompt);
  }

  Future<void> loadReflections() async {
    final box = await HiveService.getReflectionBox();
    setState(() {
      _reflections = box.values.toList().cast<BlockReflection>();
    });
  }

  void onStartBlock(int hour) async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);

    setState(() {
      _selectedHour = hour;
      _secondsRemaining = _focusDuration.inSeconds;
      _hasAnnouncedHalfway = false;
      _hasAnnouncedComplete = false;
    });

    final prompt = await PromptLibrary.forEvent('startBlock', locale);
    await VoiceService.speak(prompt);
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);

        final progress = timerProgress;

        if (!_hasAnnouncedHalfway && progress >= 0.5) {
          _hasAnnouncedHalfway = true;
          await VoiceService.speak('You’re halfway through. Keep going!');
          final hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 100);
          }
        }
      } else {
        timer.cancel();
        if (!_hasAnnouncedComplete) {
          _hasAnnouncedComplete = true;
          await VoiceService.speak('Focus block complete. Well done!');
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

  void onCompleteBlock() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    final prompt = await PromptLibrary.forEvent('completeBlock', locale);
    await VoiceService.speak(prompt);

    if (_selectedHour != null) {
      SessionLogger.logBlock(_selectedHour!);
    }
    debugPrint('Block $_selectedHour completed.');
  }

  double get timerProgress {
    if (_selectedHour == null || _focusDuration.inSeconds == 0) return 0.0;
    return 1.0 - (_secondsRemaining / _focusDuration.inSeconds);
  }

  BlockStatus getBlockStatus(int hour) {
    final reflection = _reflections.firstWhere(
      (r) => r.hour == hour,
      orElse: () => BlockReflection(hour: hour),
    );

    if (reflection.note != null || reflection.label != null) {
      return BlockStatus.completed;
    }

    return BlockStatus.idle;
  }

  Color getBlockColor(BlockStatus status) {
    switch (status) {
      case BlockStatus.completed:
        return Colors.greenAccent;
      case BlockStatus.idle:
        return Colors.yellowAccent;
      case BlockStatus.skipped:
        return Colors.redAccent;
    }
  }

  String getMoodEmoji(String? mood) {
    switch (mood) {
      case 'focused':
        return '🧠';
      case 'tired':
        return '😴';
      case 'happy':
        return '😊';
      case 'anxious':
        return '😟';
      default:
        return '';
    }
  }

  Widget buildSummary() {
    final completed = _reflections.where((r) => r.note != null || r.label != null).length;
    final idle = 24 - completed;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('✅ $completed'),
          Text('🟡 $idle'),
        ],
      ),
    );
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
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              padding: const EdgeInsets.all(8),
              children: blocks.map((hour) {
                final isSelected = _selectedHour == hour;
                final timeDisplay = isSelected
                    ? '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}'
                    : '$hour:00';

                final reflection = _reflections.firstWhere(
                  (r) => r.hour == hour,
                  orElse: () => BlockReflection(hour: hour),
                );

                final status = getBlockStatus(hour);
                final moodEmoji = getMoodEmoji(reflection.mood);

                return GestureDetector(
                  onTap: () {
                    if (_selectedHour != hour || _secondsRemaining == 0) {
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
                            await loadReflections();
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
                        color: getBlockColor(status),
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
                          if (moodEmoji.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Text(moodEmoji, style: const TextStyle(fontSize: 16)),
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
          ),
          buildSummary(),
        ],
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
