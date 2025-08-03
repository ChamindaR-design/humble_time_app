import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/providers/tts_provider.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/models/task_type.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

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
    final tts = ref.read(ttsProvider);

    final List<ScheduleBlock> blocks = [
      ScheduleBlock(
        title: 'Morning Focus',
        timeRange: '08:00 - 10:00',
        task: 'Deep work on priority tasks',
        type: TaskType.focusBlock,
      ),
      ScheduleBlock(
        title: 'Midday Recharge',
        timeRange: '12:00 - 13:00',
        task: 'Lunch + Restorative break',
        type: TaskType.breakBlock,
      ),
      ScheduleBlock(
        title: 'Afternoon Flow',
        timeRange: '14:00 - 16:30',
        task: 'Meetings and creative work',
        type: TaskType.other,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Speak Schedule',
            onPressed: () {
              if (settingsProvider.settings.enableVoiceNudge) {
                tts.speak('Here is your daily schedule. Swipe through blocks to review.');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          final block = blocks[index];
          return _buildScheduleCard(context, block, ref);
        },
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    ScheduleBlock block,
    WidgetRef ref,
  ) {
    final tts = ref.read(ttsProvider);
    final settings = ref.read(userSettingsProvider).settings;

    return Semantics(
      label: '${block.type.name} block: ${block.title}',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            block.title,
            semanticsLabel: '${block.title} block',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${block.timeRange}\n${block.task}'),
          isThreeLine: true,
          leading: const Icon(Icons.schedule),
          onTap: () {
            if (settings.enableVoiceNudge) {
              final affirmation = _getAffirmation(block.type);
              tts.speak('${block.title} block: ${block.task}. $affirmation');
            }
          },
        ),
      ),
    );
  }
}

class ScheduleBlock {
  final String title;
  final String timeRange;
  final String task;
  final TaskType type;

  ScheduleBlock({
    required this.title,
    required this.timeRange,
    required this.task,
    required this.type,
  });
}
