/*import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Humble Time Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Log History'),
              onTap: () => Navigator.pushNamed(context, '/log'),
            ),
            // Add more navigation ListTiles here
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
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
              onPressed: () => Navigator.pushNamed(context, '/log'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: Text(local.actuals),
              onPressed: () => Navigator.pushNamed(context, '/actuals'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.timelapse),
              label: Text(local.pacing),
              onPressed: () => Navigator.pushNamed(context, '/pacing'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(local.scheduler),
              onPressed: () => Navigator.pushNamed(context, '/scheduler'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: Text(local.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}


