import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/core/utils/block_generator.dart';
//import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/features/scheduler/widgets/schedule_block.dart';

class SchedulerScreen extends StatelessWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    final userSettings = settingsProvider.settings;

    final blocks = generateTimeBlocks(userSettings);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: ListView.builder(
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
    );
  }
}
