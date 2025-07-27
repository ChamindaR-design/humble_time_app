import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/core/providers/tts_provider.dart';
import 'package:humble_time_app/core/utils/block_generator.dart';
import 'package:humble_time_app/features/scheduler/widgets/schedule_block.dart';

class SchedulerScreen extends ConsumerWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user settings from the Riverpod provider
    final settingsProvider = ref.watch(userSettingsProvider);
    final userSettings = settingsProvider.settings;

    // Generate time blocks based on user preferences
    final blocks = generateTimeBlocks(userSettings);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(
        children: [
          // Voice feedback button
          ElevatedButton(
            onPressed: () {
              final tts = ref.read(ttsProvider);
              // Optional: only speak if voice nudges are enabled
              if (userSettings.enableVoiceNudge) {
                tts.speak('Block started!');
              }
            },
            child: const Text('Start Block'),
          ),
          // Render the time blocks
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                return ScheduleBlock(
                  title: block.label,
                  duration: block.duration,
                  taskType: block.taskType,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
