import 'package:flutter/material.dart';
import 'package:humble_time_app/core/localization/humble_localizations.dart' as core_localization;
import 'package:humble_time_app/core/services/voice_service.dart';
//import 'package:humble_time_app/core/models/user_settings.dart';
import 'package:humble_time_app/features/scheduler/widgets/schedule_block.dart';

List<ScheduleBlock> generateDynamicBlocks(BuildContext context, UserSettings userSettings) {
  final localizations = core_localization.HumbleLocalizations.of(context);
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
