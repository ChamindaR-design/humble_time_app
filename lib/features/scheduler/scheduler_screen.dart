import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/core/providers/tts_provider.dart';
import 'package:humble_time_app/core/utils/block_generator.dart';
import 'package:humble_time_app/features/scheduler/widgets/schedule_block.dart';
import 'package:humble_time_app/models/task_type.dart';

class SchedulerScreen extends ConsumerWidget {
  const SchedulerScreen({super.key});

  String _getAffirmation(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return 'Let’s dive in and stay present.';
      case TaskType.breakBlock:
        return 'Pause and recharge. You’ve earned it.';
      case TaskType.meditation:
        return 'Breathe deeply. This moment is yours.';
      case TaskType.other:
        return 'Time to move forward mindfully.';
      //default:
      //  return 'Take this moment as you need it.'; // ✅ Fallback protection
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsProvider = ref.watch(userSettingsProvider);
    final userSettings = settingsProvider.settings;
    final blocks = generateTimeBlocks(userSettings);
    final tts = ref.read(ttsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (userSettings.enableVoiceNudge && blocks.isNotEmpty) {
                final affirmation = _getAffirmation(blocks.first.taskType);
                tts.speak('Starting your ${blocks.first.label}. $affirmation');
              }
            },
            child: const Text('Start Block'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                return AnimatedSlide(
                  offset: const Offset(1, 0),
                  duration: Duration(milliseconds: 250 + index * 100),
                  curve: Curves.easeOut,
                  child: ScheduleBlock(
                    title: block.label,
                    duration: block.duration,
                    taskType: block.taskType,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
