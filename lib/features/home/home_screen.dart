import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/l10n/humble_localizations.dart';
import 'package:humble_time_app/widgets/narrated_text.dart'; // <-- Import voice-aware text

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
          speakOnBuild: false, // no need to speak this
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NarratedText( // <-- subtle emotional cue
              text: 'What would you like to do next?',
              baseFontSize: 18,
              style: const TextStyle(fontWeight: FontWeight.w500),
              speakOnBuild: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: Text(local.logHistory),
              onPressed: () => context.push('/log'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: Text(local.actuals),
              onPressed: () => context.push('/actuals'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.timelapse),
              label: Text(local.pacing),
              onPressed: () => context.push('/pacing'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(local.scheduler),
              onPressed: () => context.push('/scheduler'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: Text(local.settings),
              onPressed: () => context.push('/settings'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.mood),
              label: Text(local.mood),
              onPressed: () => context.push('/mood'),  
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.schedule),
              label: Text(local.timeMosaicPlanner),
              onPressed: () => context.push('/time-mosaic-planner'),  
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: Text(local.journalReview),
              onPressed: () => context.push('/journal-review'),
            ),
          ],
        ),
      ),
    );
  }
}
