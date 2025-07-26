//import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/core/services/voice_service.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/models/user_settings.dart';

List<TimeBlock> generateTimeBlocks(UserSettings userSettings) {
  final List<TimeBlock> blocks = [];

  for (int i = 0; i < userSettings.blockCount; i++) {
    blocks.add(TimeBlock(
      label: 'Focus',
      duration: userSettings.focusBlockDuration,
      isBreak: false,
    ));

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
