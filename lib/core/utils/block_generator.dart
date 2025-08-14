import 'package:flutter/material.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/models/user_settings.dart';

/// Generates a sequence of time blocks based on user settings and locale.
Future<List<TimeBlock>> generateTimeBlocks(UserSettings userSettings, Locale locale) async {
  final List<TimeBlock> blocks = [];

  for (int i = 0; i < userSettings.blockCount; i++) {
    blocks.add(TimeBlock(
      label: 'Focus',
      duration: userSettings.focusBlockDuration,
      isBreak: false,
    ));

    if (i == 0) {
      final prompt = await PromptLibrary.forEvent('startBlock', locale); // ✅ Await async call
      VoiceService.speak(prompt);
    }

    if (i < userSettings.blockCount - 1) {
      blocks.add(TimeBlock(
        label: 'Break',
        duration: userSettings.breakBlockDuration,
        isBreak: true,
      ));
    }
  }

  VoiceService.speak('Generated ${blocks.length} blocks');

  return blocks;
}
