import 'package:flutter/material.dart';

class UserSettings {
  Duration defaultBlockDuration;
  Duration focusBlockDuration;
  Duration breakBlockDuration;
  int blockCount;
  Brightness preferredBrightness;
  bool enableVoiceNudge;

  UserSettings({
    this.defaultBlockDuration = const Duration(minutes: 25),
    this.focusBlockDuration = const Duration(minutes: 25),
    this.breakBlockDuration = const Duration(minutes: 5),
    this.blockCount = 4,
    this.preferredBrightness = Brightness.light,
    this.enableVoiceNudge = false,
  });
}
