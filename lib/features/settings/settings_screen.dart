import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsProvider = ref.watch(userSettingsProvider);
    final settings = settingsProvider.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text('Accessibility & Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Enable Voice Nudges'),
            subtitle: const Text('Gentle auditory reminders for pacing'),
            value: settings.enableVoiceNudge,
            onChanged: settingsProvider.toggleVoiceNudge,
            secondary: const Icon(Icons.volume_up),
          ),

          SwitchListTile(
            title: const Text('Expanded Neurodivergent Layout'),
            subtitle: const Text('Extra spacing and reduced density'),
            value: settings.isLayoutExpanded,
            //onChanged: settingsProvider.toggleLayoutSpacing, // Not alowing to toggle
            onChanged: settingsProvider.toggleLayoutExpanded,

            secondary: const Icon(Icons.format_line_spacing),
          ),

          const Divider(height: 40),
          const Text('Voice Profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Pitch'),
          Slider(
            value: settings.voicePitch,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            label: settings.voicePitch.toStringAsFixed(1),
            onChanged: settingsProvider.setVoicePitch,
          ),
          Text('Speed'),
          Slider(
            value: settings.voiceSpeed,
            min: 0.3,
            max: 1.0,
            divisions: 14,
            label: settings.voiceSpeed.toStringAsFixed(1),
            onChanged: settingsProvider.setVoiceSpeed,
          ),

          const Divider(height: 40),
          const Text('Block Durations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Default'),
          _durationDropdown(settings.defaultBlockDuration,
              settingsProvider.updateDefaultDuration),
          Text('Focus'),
          _durationDropdown(settings.focusBlockDuration,
              settingsProvider.updateFocusDuration),
          Text('Break'),
          _durationDropdown(settings.breakBlockDuration,
              settingsProvider.updateBreakDuration),

          const Divider(height: 40),
          const Text('Appearance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<Brightness>(
            value: settings.preferredBrightness,
            items: const [
              DropdownMenuItem(
                value: Brightness.light,
                child: Text('Light Mode'),
              ),
              DropdownMenuItem(
                value: Brightness.dark,
                child: Text('Dark Mode'),
              ),
            ],
            onChanged: (newBrightness) {
              if (newBrightness != null) {
                settingsProvider.setPreferredBrightness(newBrightness);
              }
            },
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: settings.colorPalette,
            items: ['Indigo Calm', 'Teal Clarity', 'Pink Kindness']
                .map((theme) => DropdownMenuItem(
                      value: theme,
                      child: Text(theme),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                settingsProvider.setColorPalette(val);
              }
            },
          ),
        ],
      ),
    );
  }

  DropdownButton<Duration> _durationDropdown(
      Duration current, void Function(Duration) onChange) {
    return DropdownButton<Duration>(
      value: current,
      items: [
        const Duration(minutes: 5),
        const Duration(minutes: 15),
        const Duration(minutes: 25),
        const Duration(minutes: 45),
        const Duration(minutes: 60),
      ].map((duration) => DropdownMenuItem(
            value: duration,
            child: Text('${duration.inMinutes} minutes'),
          )).toList(),
      onChanged: (duration) {
        if (duration != null) {
          onChange(duration);
        }
      },
    );
  }
}
