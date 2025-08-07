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
import 'package:humble_time_app/utils/clean_malformed_reflections.dart';

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
  await cleanMalformedReflections(); // Optional: only in dev
  await VoiceService.init();
  debugPrint('VoiceService initialized with TTS settings');

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
      routerConfig: router,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('si'),
        Locale('ja'),
      ],
      locale: locale,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const VoiceInitializer(), // 👈 Ambient voice trigger
          ],
        );
      },
    );
  }
}

class VoiceInitializer extends StatefulWidget {
  const VoiceInitializer({super.key});

  @override
  State<VoiceInitializer> createState() => _VoiceInitializerState();
}

class _VoiceInitializerState extends State<VoiceInitializer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final startupPrompt = PromptLibrary.forEvent('startBlock');
      debugPrint('VoiceInitializer: Startup prompt — "$startupPrompt"');
      VoiceService.speak(startupPrompt);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
