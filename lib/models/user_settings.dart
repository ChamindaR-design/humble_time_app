import 'package:flutter/material.dart';

class UserSettings {
  // 🧩 Block timing settings
  Duration defaultBlockDuration;
  Duration focusBlockDuration;
  Duration breakBlockDuration;
  int blockCount;

  // 🎨 Appearance
  Brightness preferredBrightness;
  String colorPalette;

  // 🔊 Voice nudges
  bool enableVoiceNudge;
  double voicePitch;
  double voiceSpeed;

  // ♿ Layout and animations
  bool isLayoutExpanded;
  bool enableAnimations;
  bool enableLayoutSpacing;

  UserSettings({
    this.defaultBlockDuration = const Duration(minutes: 25),
    this.focusBlockDuration = const Duration(minutes: 25),
    this.breakBlockDuration = const Duration(minutes: 5),
    this.blockCount = 4,
    this.preferredBrightness = Brightness.light,
    this.colorPalette = 'Indigo Calm',
    this.enableVoiceNudge = false,
    this.voicePitch = 1.0,
    this.voiceSpeed = 0.5,
    this.isLayoutExpanded = false,
    this.enableAnimations = true,
    this.enableLayoutSpacing = false,
  });

  UserSettings.indigoCalm()
      : defaultBlockDuration = const Duration(minutes: 25),
        focusBlockDuration = const Duration(minutes: 25),
        breakBlockDuration = const Duration(minutes: 5),
        blockCount = 4,
        preferredBrightness = Brightness.light,
        colorPalette = 'Indigo Calm',
        enableVoiceNudge = false,
        voicePitch = 1.0,
        voiceSpeed = 0.5,
        isLayoutExpanded = false,
        enableAnimations = true,
        enableLayoutSpacing = false;

  UserSettings copyWith({
    Duration? defaultBlockDuration,
    Duration? focusBlockDuration,
    Duration? breakBlockDuration,
    int? blockCount,
    Brightness? preferredBrightness,
    String? colorPalette,
    bool? enableVoiceNudge,
    double? voicePitch,
    double? voiceSpeed,
    bool? isLayoutExpanded,
    bool? enableAnimations,
    bool? enableLayoutSpacing,
  }) {
    return UserSettings(
      defaultBlockDuration: defaultBlockDuration ?? this.defaultBlockDuration,
      focusBlockDuration: focusBlockDuration ?? this.focusBlockDuration,
      breakBlockDuration: breakBlockDuration ?? this.breakBlockDuration,
      blockCount: blockCount ?? this.blockCount,
      preferredBrightness: preferredBrightness ?? this.preferredBrightness,
      colorPalette: colorPalette ?? this.colorPalette,
      enableVoiceNudge: enableVoiceNudge ?? this.enableVoiceNudge,
      voicePitch: voicePitch ?? this.voicePitch,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      isLayoutExpanded: isLayoutExpanded ?? this.isLayoutExpanded,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableLayoutSpacing: enableLayoutSpacing ?? this.enableLayoutSpacing,
    );
  }
}
