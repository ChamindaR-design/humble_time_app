import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/l10n/humble_localizations.dart';
import 'package:humble_time_app/widgets/narrated_text.dart';
import 'package:humble_time_app/features/pacing/voice_initializer.dart'; // 👈 Add this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = HumbleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: NarratedText(
          text: local.appTitle,
          baseFontSize: 20,
          speakOnBuild: false,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NarratedText(
                  text: 'What would you like to do next?',
                  baseFontSize: 18,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  speakOnBuild: true,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: Text(local.logHistory),
                  onPressed: () => context.go('/log'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: Text(local.actuals),
                  onPressed: () => context.go('/actuals'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.timelapse),
                  label: Text(local.pacing),
                  onPressed: () => context.go('/pacing'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(local.scheduler),
                  onPressed: () => context.go('/scheduler'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: Text(local.settings),
                  onPressed: () => context.go('/settings'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.mood),
                  label: Text(local.mood),
                  onPressed: () => context.go('/mood'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.schedule),
                  label: Text(local.timeMosaicPlanner),
                  onPressed: () => context.go('/time-mosaic-planner'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.book),
                  label: Text(local.journalReview),
                  onPressed: () => context.go('/journal-review'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.insights),
                  label: Text(local.reflectionHistory),
                  onPressed: () => context.go('/reflection-history'),
                ),
              ],
            ),
          ),
          const VoiceInitializer(), // ✅ Fires voice once after layout completes
        ],
      ),
    );
  }
}
