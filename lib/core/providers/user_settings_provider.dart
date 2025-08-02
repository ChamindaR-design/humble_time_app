import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/models/user_settings.dart';

class UserSettingsProvider extends ChangeNotifier {
  UserSettings _settings;

  UserSettingsProvider(this._settings);

  UserSettings get settings => _settings;

  void toggleVoiceNudge(bool value) {
    _settings = _settings.copyWith(enableVoiceNudge: value);
    notifyListeners();
  }

  void toggleAnimations(bool value) {
    _settings = _settings.copyWith(enableAnimations: value);
    notifyListeners();
  }

  void toggleLayoutExpanded(bool value) {
    _settings = _settings.copyWith(isLayoutExpanded: value);
    notifyListeners();
  }

  void toggleLayoutSpacing(bool value) {
    _settings = _settings.copyWith(enableLayoutSpacing: value);
    notifyListeners();
  }

  void setVoicePitch(double pitch) {
    _settings = _settings.copyWith(voicePitch: pitch);
    notifyListeners();
  }

  void setVoiceSpeed(double speed) {
    _settings = _settings.copyWith(voiceSpeed: speed);
    notifyListeners();
  }

  void updateDefaultDuration(Duration duration) {
    _settings = _settings.copyWith(defaultBlockDuration: duration);
    notifyListeners();
  }

  void updateFocusDuration(Duration duration) {
    _settings = _settings.copyWith(focusBlockDuration: duration);
    notifyListeners();
  }

  void updateBreakDuration(Duration duration) {
    _settings = _settings.copyWith(breakBlockDuration: duration);
    notifyListeners();
  }

  void setPreferredBrightness(Brightness brightness) {
    _settings = _settings.copyWith(preferredBrightness: brightness);
    notifyListeners();
  }

  void setColorPalette(String paletteName) {
    _settings = _settings.copyWith(colorPalette: paletteName);
    notifyListeners();
  }

  void updateSettings(UserSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}

final userSettingsProvider = ChangeNotifierProvider<UserSettingsProvider>((ref) {
  return UserSettingsProvider(
    UserSettings(
      enableVoiceNudge: true,
      enableAnimations: true,
      isLayoutExpanded: false,
      enableLayoutSpacing: false,
      voicePitch: 1.0,
      voiceSpeed: 0.7,
      defaultBlockDuration: Duration(minutes: 25),
      focusBlockDuration: Duration(minutes: 45),
      breakBlockDuration: Duration(minutes: 15),
      preferredBrightness: Brightness.light,
      colorPalette: 'Indigo Calm',
    ),
  );
});
