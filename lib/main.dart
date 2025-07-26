import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:humble_time_app/features/home/home_screen.dart';
import 'package:humble_time_app/widgets/log_history_widget.dart';
import 'package:humble_time_app/features/actuals/actuals_screen.dart';
import 'package:humble_time_app/features/pacing/pacing_screen.dart';
import 'package:humble_time_app/features/scheduler/scheduler_screen.dart' as scheduler;
import 'package:humble_time_app/features/settings/settings_screen.dart';

import 'package:humble_time_app/core/themes/humble_theme.dart';
import 'package:humble_time_app/core/localization/humble_localizations.dart';
import 'package:humble_time_app/core/services/voice_service.dart';
import 'package:humble_time_app/core/providers/user_settings_provider.dart' as core;
import 'package:humble_time_app/models/time_log_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VoiceService.init();

  final List<TimeLogEntry> logEntries = [
    TimeLogEntry(
      startTime: DateTime.parse('2025-07-25T08:00:00'),
      endTime: DateTime.parse('2025-07-25T09:30:00'),
      description: 'Flutter development session',
    ),
    TimeLogEntry(
      startTime: DateTime.parse('2025-07-25T10:00:00'),
      endTime: DateTime.parse('2025-07-25T10:45:00'),
      description: 'Accessibility testing',
    ),
  ];

  final FlutterTts ttsInstance = FlutterTts();

  runApp(
    ChangeNotifierProvider(
      create: (_) => core.UserSettingsProvider(),
      child: HumbleApp(
        entries: logEntries,
        tts: ttsInstance,
      ),
    ),
  );
}

class HumbleApp extends StatelessWidget {
  final List<TimeLogEntry> entries;
  final FlutterTts tts;

  const HumbleApp({super.key, required this.entries, required this.tts});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Humble Time Tracker',
      debugShowCheckedModeBanner: false,
      theme: HumbleTheme.light(),
      darkTheme: HumbleTheme.dark(),
      localizationsDelegates: const [
        HumbleLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', ''),
        Locale('si', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/log': (context) => LogHistoryWidget(
          entries: entries,
          tts: tts,
        ),
        '/actuals': (context) => ActualsScreen(),
        '/pacing': (context) => PacingScreen(),
        '/scheduler': (context) => scheduler.SchedulerScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
