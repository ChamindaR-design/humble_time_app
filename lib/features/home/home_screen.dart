import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/l10n/humble_localizations.dart'; // Adjust this import if needed

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = HumbleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(local.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: Text(local.logHistory),
              //onPressed: () => context.go('/log'),
              onPressed: () => context.push('/log'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: Text(local.actuals),
              //onPressed: () => context.go('/actuals'),
              onPressed: () => context.push('/actuals'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.timelapse),
              label: Text(local.pacing),
              //onPressed: () => context.go('/pacing'),
              onPressed: () => context.push('/pacing'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(local.scheduler),
              //onPressed: () => context.go('/scheduler'),
              onPressed: () => context.push('/scheduler'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: Text(local.settings),
              //onPressed: () => context.go('/settings'),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
