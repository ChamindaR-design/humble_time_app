import 'package:flutter/material.dart';

class UserSettings {
  final bool enableVoiceNudge;
  final Duration defaultBlockDuration;
  final Brightness preferredBrightness;
  // You can expand this with pacing aid preferences, focus modes, etc.

  const UserSettings({
    this.enableVoiceNudge = true,
    this.defaultBlockDuration = const Duration(minutes: 25),
    this.preferredBrightness = Brightness.light,
  });

  UserSettings copyWith({
    bool? enableVoiceNudge,
    Duration? defaultBlockDuration,
    Brightness? preferredBrightness,
  }) {
    return UserSettings(
      enableVoiceNudge: enableVoiceNudge ?? this.enableVoiceNudge,
      defaultBlockDuration: defaultBlockDuration ?? this.defaultBlockDuration,
      preferredBrightness: preferredBrightness ?? this.preferredBrightness,
    );
  }
}

class UserSettingsProvider extends ChangeNotifier {
  UserSettingsProvider();
  UserSettings _settings = const UserSettings();

  UserSettings get settings => _settings;

  void toggleVoiceNudge(bool value) {
    _settings = _settings.copyWith(enableVoiceNudge: value);
    notifyListeners();
  }

  void setDefaultDuration(Duration duration) {
    _settings = _settings.copyWith(defaultBlockDuration: duration);
    notifyListeners();
  }

  void setPreferredBrightness(Brightness brightness) {
    _settings = _settings.copyWith(preferredBrightness: brightness);
    notifyListeners();
  }
}
