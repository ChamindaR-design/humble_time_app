import 'package:shared_preferences/shared_preferences.dart';
import 'package:humble_time_app/models/user_settings.dart';
import 'package:flutter/material.dart';

class SettingsStorage {
  static Future<void> save(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('enableVoiceNudge', settings.enableVoiceNudge);
    await prefs.setBool('enableAnimations', settings.enableAnimations);
    await prefs.setBool('isLayoutExpanded', settings.isLayoutExpanded);
    await prefs.setBool('enableLayoutSpacing', settings.enableLayoutSpacing);

    await prefs.setDouble('voicePitch', settings.voicePitch);
    await prefs.setDouble('voiceSpeed', settings.voiceSpeed);

    await prefs.setInt('blockCount', settings.blockCount);
    await prefs.setInt('defaultBlockDuration', settings.defaultBlockDuration.inMinutes);
    await prefs.setInt('focusBlockDuration', settings.focusBlockDuration.inMinutes);
    await prefs.setInt('breakBlockDuration', settings.breakBlockDuration.inMinutes);

    await prefs.setString('colorPalette', settings.colorPalette);
    await prefs.setString(
      'preferredBrightness',
      settings.preferredBrightness == Brightness.dark ? 'dark' : 'light',
    );
  }

  static Future<UserSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return UserSettings(
      enableVoiceNudge: prefs.getBool('enableVoiceNudge') ?? false,
      enableAnimations: prefs.getBool('enableAnimations') ?? true,
      isLayoutExpanded: prefs.getBool('isLayoutExpanded') ?? false,
      enableLayoutSpacing: prefs.getBool('enableLayoutSpacing') ?? false,
      voicePitch: prefs.getDouble('voicePitch') ?? 1.0,
      voiceSpeed: prefs.getDouble('voiceSpeed') ?? 0.5,
      blockCount: prefs.getInt('blockCount') ?? 4,
      defaultBlockDuration: Duration(minutes: prefs.getInt('defaultBlockDuration') ?? 25),
      focusBlockDuration: Duration(minutes: prefs.getInt('focusBlockDuration') ?? 25),
      breakBlockDuration: Duration(minutes: prefs.getInt('breakBlockDuration') ?? 5),
      colorPalette: prefs.getString('colorPalette') ?? 'Indigo Calm',
      preferredBrightness:
          prefs.getString('preferredBrightness') == 'dark' ? Brightness.dark : Brightness.light,
    );
  }
}
