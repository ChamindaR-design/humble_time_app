import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/*class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    final settings = settingsProvider.settings;

    return Scaffold(*/
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
            onChanged: (val) =>
                settingsProvider.toggleVoiceNudge(val),
            secondary: const Icon(Icons.volume_up),
          ),

          const Divider(height: 40),
          const Text('Default Block Duration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<Duration>(
            value: settings.defaultBlockDuration,
            items: [
              const Duration(minutes: 25),
              const Duration(minutes: 45),
              const Duration(minutes: 60),
            ].map((duration) => DropdownMenuItem(
                  value: duration,
                  child: Text('${duration.inMinutes} minutes'),
                )).toList(),
            onChanged: (duration) {
              if (duration != null) {
                settingsProvider.updateDefaultDuration(duration);
              }
            },
          ),

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
              settingsProvider.setPreferredBrightness(newBrightness!);
            },
          ),
        ],
      ),
    );
  }
}
