import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/providers/tts_provider.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsProvider = ref.watch(userSettingsProvider);
    final tts = ref.read(ttsProvider);

    final enableVoice = settingsProvider.settings.enableVoiceNudge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              if (enableVoice) {
                tts.speak('Here is your daily schedule. Swipe through blocks to review.');
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildScheduleCard(
            context,
            title: 'Morning Focus',
            timeRange: '08:00 - 10:00',
            task: 'Deep work on priority tasks',
          ),
          _buildScheduleCard(
            context,
            title: 'Midday Recharge',
            timeRange: '12:00 - 13:00',
            task: 'Lunch + Restorative break',
          ),
          _buildScheduleCard(
            context,
            title: 'Afternoon Flow',
            timeRange: '14:00 - 16:30',
            task: 'Meetings and creative work',
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, {
    required String title,
    required String timeRange,
    required String task,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('$timeRange\n$task'),
        isThreeLine: true,
        leading: const Icon(Icons.schedule),
        onTap: () {
          final tts = ProviderScope.containerOf(context).read(ttsProvider);
          tts.speak('$title block: $task from $timeRange');
        },
      ),
    );
  }
}
