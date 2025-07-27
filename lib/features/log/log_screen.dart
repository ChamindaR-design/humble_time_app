import 'package:flutter/material.dart';
import 'package:humble_time_app/l10n/humble_localizations.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = HumbleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.logHistory), // Localized title
      ),
      body: const Center(
        child: Text('Log screen coming soon!'),
      ),
    );
  }
}
