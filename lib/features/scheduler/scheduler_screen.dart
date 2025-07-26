import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/schedule_block.dart';
import 'package:humble_time_app/core/utils/block_generator.dart' as utils;
//import 'package:humble_time_app/core/models/user_settings.dart';

// Mock UserSettingsProvider – replace with your actual implementation
class UserSettingsProvider with ChangeNotifier {
  final UserSettings settings = UserSettings(
    focusBlockDuration: 25,
    breakBlockDuration: 5,
    voiceNudgeEnabled: true,
  );
}

class SchedulerScreen extends StatelessWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettingsProvider>(context).settings;
    final blocks = utils.generateDynamicBlocks(context, userSettings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              "Plan your time in gentle blocks.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose durations, assign focus areas, and add optional pacing aids.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Icon(Icons.schedule, size: 64, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Scheduler tools coming soon...",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 30),
            ...blocks,
          ],
        ),
      ),
    );
  }
}
