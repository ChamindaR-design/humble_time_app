import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/models/task_type.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/core/navigation/bottom_nav_bar.dart'; // Optional

class BlockSessionScreen extends StatefulWidget {
  final TimeBlock block;

  const BlockSessionScreen({super.key, required this.block});

  @override
  State<BlockSessionScreen> createState() => _BlockSessionScreenState();
}

class _BlockSessionScreenState extends State<BlockSessionScreen> {
  late Duration remaining;
  Timer? _timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    remaining = widget.block.duration;
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  Future<void> _startSession() async {
    final locale = Localizations.localeOf(context);
    final startPrompt = await PromptLibrary.forEvent('sessionStart', locale, param: widget.block.label);
    VoiceService.speak(startPrompt);
    HapticFeedback.selectionClick();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && mounted) {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
        });

        if (remaining.inSeconds == widget.block.duration.inSeconds ~/ 2) {
          VoiceService.speak("You're halfway through. Keep going.");
        }

        if (remaining.inSeconds <= 0) {
          timer.cancel();
          _endSession();
        }
      }
    });
  }

  Future<void> _endSession() async {
    final locale = Localizations.localeOf(context);
    final endPrompt = await PromptLibrary.forEvent('sessionEnd', locale, param: widget.block.label);
    VoiceService.speak(endPrompt);
    HapticFeedback.heavyImpact();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Session Complete'),
        content: const Text('Would you like to reflect or continue?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog

              final logEntry = LogEntry(
                startTime: DateTime.now().subtract(widget.block.duration),
                endTime: DateTime.now(),
                blockType: _mapTaskTypeToLogBlockType(widget.block.taskType),
                usedVoicePrompts: true,
                note: 'Session completed',
                mood: null,
              );

              VoiceService.speak("Session complete. Opening reflection.");
              context.push('/reflection', extra: logEntry);
            },
            child: const Text('Reflect'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // ✅ Resume session (no action needed here)
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  LogBlockType _mapTaskTypeToLogBlockType(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return LogBlockType.focusBlock;
      case TaskType.breakBlock:
        return LogBlockType.breakBlock;
      case TaskType.meditation:
        return LogBlockType.meditation;
      case TaskType.other:
        return LogBlockType.other;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePause() {
    setState(() => isPaused = !isPaused);
    HapticFeedback.selectionClick();
    VoiceService.speak(isPaused ? "Paused" : "Resuming");
  }

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Semantics(
      label: 'Block session screen',
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.block.label),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'End session',
            onPressed: () {
              _timer?.cancel();
              context.go('/'); // ✅ Exit session
            },
          ),
        ),
        bottomNavigationBar: const BottomNavBar(), // ✅ Optional
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Time remaining: $minutes minutes and $seconds seconds',
                child: Text(
                  '$minutes:$seconds',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _getAffirmation(widget.block.taskType),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(isPaused ? 'Resume' : 'Pause'),
                onPressed: _togglePause,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAffirmation(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return 'Stay present. You’re doing great.';
      case TaskType.breakBlock:
        return 'Enjoy this pause. Let yourself recharge.';
      case TaskType.meditation:
        return 'Breathe and be here now.';
      case TaskType.other:
        return 'Use this time with intention.';
    }
  }
}
