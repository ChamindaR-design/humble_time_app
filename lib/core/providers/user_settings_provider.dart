import 'package:flutter/material.dart';
import 'package:humble_time_app/models/user_settings.dart';

class UserSettingsProvider with ChangeNotifier {
  final UserSettings _settings = UserSettings();

  UserSettings get settings => _settings;

  void toggleVoiceNudge(bool value) {
    _settings.enableVoiceNudge = value;
    notifyListeners();
  }

  void setPreferredBrightness(Brightness brightness) {
    _settings.preferredBrightness = brightness;
    notifyListeners();
  }

  void updateDefaultDuration(Duration duration) {
    _settings.defaultBlockDuration = duration;
    _settings.focusBlockDuration = duration;
    notifyListeners();
  }

  void setBlockCount(int count) {
    _settings.blockCount = count;
    notifyListeners();
  }

  void setBreakDuration(Duration duration) {
    _settings.breakBlockDuration = duration;
    notifyListeners();
  }
}
