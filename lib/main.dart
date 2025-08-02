import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:humble_time_app/core/themes/app_theme.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/core/navigation/go_router.dart';
import 'package:humble_time_app/core/providers/theme_provider.dart';
import 'package:humble_time_app/core/providers/localization_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';
import 'package:humble_time_app/models/time_log_entry.dart';

/// Provider for time log entries (example demo data)
final logEntriesProvider = Provider<List<TimeLogEntry>>((ref) => [
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
]);

/// Provider for global FlutterTts instance
final ttsProvider = Provider<FlutterTts>((ref) => FlutterTts());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize voice engine and speak startup prompt
  await VoiceService.init();
  VoiceService.speak(PromptLibrary.forEvent('startBlock'));

  runApp(
    ProviderScope(
      child: HumbleApp(
        entries: [
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
        ],
        tts: FlutterTts(),
      ),
    ),
  );
}

class HumbleApp extends ConsumerWidget {
  final List<TimeLogEntry> entries;
  final FlutterTts tts;

  const HumbleApp({
    super.key,
    required this.entries,
    required this.tts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Humble Time Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router, // Defined in go_router.dart
      localizationsDelegates: [
        AppLocalizations.delegate, // Your custom app localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('si'), // Sinhala
        Locale('ja'), // Japanese
      ],
      locale: locale,
    );
  }
}
