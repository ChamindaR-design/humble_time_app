import 'package:flutter/material.dart';
import 'package:humble_time_app/core/services/voice_service.dart';

// If HumbleLocalizations and UserSettings aren't implemented fully yet,
// We'll comment their imports and mock minimal functionality

// import 'package:humble_time_app/core/localization/humble_localizations.dart';
// import 'package:humble_time_app/core/models/user_settings.dart';

enum TaskType { work, breakTime, focus }

class UserSettings {
  final int focusBlockDuration;
  final int breakBlockDuration;
  final bool voiceNudgeEnabled;

  UserSettings({
    required this.focusBlockDuration,
    required this.breakBlockDuration,
    required this.voiceNudgeEnabled,
  });
}

// Optional: Replace with actual localization integration
class HumbleLocalizations {
  static HumbleLocalizations of(BuildContext context) => HumbleLocalizations();

  String get focusBlockTitle => "Focus Block";
  String get breakBlockTitle => "Break Block";
  String get voiceFocusStart => "Starting Focus Block";
  String get voiceBreakStart => "Time for a break";
}

class ScheduleBlock extends StatelessWidget {
  final String title;
  final Duration duration;
  final Color blockColor;
  final bool enableVoiceNudge;
  final TaskType taskType;
  final double progressRatio;
  final VoidCallback? onStart;

  const ScheduleBlock({
    super.key,
    required this.title,
    required this.duration,
    required this.taskType,
    this.blockColor = Colors.indigo,
    this.enableVoiceNudge = false,
    this.progressRatio = 0.0,
    this.onStart,
  });

  IconData getIconForType(TaskType type) {
    switch (type) {
      case TaskType.work:
        return Icons.work;
      case TaskType.breakTime:
        return Icons.coffee;
      case TaskType.focus:
        return Icons.psychology;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: blockColor.withAlpha((0.1 * 255).toInt()), // replaces deprecated withOpacity
          child: ListTile(
            leading: Icon(getIconForType(taskType), color: blockColor),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${duration.inMinutes} minutes • Scheduled'),
            trailing: enableVoiceNudge
                ? IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      if (onStart != null) {
                        onStart!();
                      } else {
                        VoiceService.speak(
                          "Starting block: $title for ${duration.inMinutes} minutes",
                        );
                      }
                    },
                  )
                : null,
          ),
        ),
        if (progressRatio > 0.0)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width * progressRatio,
                color: blockColor,
              ),
            ),
          ),
      ],
    );
  }
}

List<ScheduleBlock> generateDynamicBlocks(
    BuildContext context, UserSettings userSettings) {
  final localizations = HumbleLocalizations.of(context);
  final List<ScheduleBlock> blocks = [];

  final blockConfigs = [
    {
      "title": localizations.focusBlockTitle,
      "duration": Duration(minutes: userSettings.focusBlockDuration),
      "blockColor": Colors.blue,
      "taskType": TaskType.focus,
      "voicePrompt": localizations.voiceFocusStart,
    },
    {
      "title": localizations.breakBlockTitle,
      "duration": Duration(minutes: userSettings.breakBlockDuration),
      "blockColor": Colors.green,
      "taskType": TaskType.breakTime,
      "voicePrompt": localizations.voiceBreakStart,
    },
  ];

  for (final config in blockConfigs) {
    blocks.add(
      ScheduleBlock(
        title: config["title"] as String,
        duration: config["duration"] as Duration,
        blockColor: config["blockColor"] as Color,
        taskType: config["taskType"] as TaskType,
        enableVoiceNudge: userSettings.voiceNudgeEnabled,
        onStart: () {
          if (userSettings.voiceNudgeEnabled) {
            VoiceService.speak(config["voicePrompt"] as String);
          }
        },
      ),
    );
  }

  return blocks;
}
