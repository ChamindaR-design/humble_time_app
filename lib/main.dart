import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:humble_time_app/core/themes/app_theme.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/core/navigation/go_router.dart';
import 'package:humble_time_app/core/providers/localization_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';
import 'package:humble_time_app/models/time_log_entry.dart';
import 'package:humble_time_app/utils/clean_malformed_reflections.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_service.dart';
import 'dart:developer' as dev;

import 'package:humble_time_app/core/providers/user_settings_provider.dart';

import 'package:flutter/foundation.dart';

//Actuals Screens
import 'package:humble_time_app/models/actuals_entry.dart';
import 'package:humble_time_app/features/actuals/services/actuals_store.dart';

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

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cleanMalformedReflections(); // Optional: only in dev
  await VoiceService.init();
  debugPrint('VoiceService initialized with TTS settings');
  await Hive.initFlutter();
  await HiveService.init();

  //if (!bool.fromEnvironment('dart.vm.product')) {
  if (!kReleaseMode) {
    final reflections = HiveService.getAllReflections();
    for (final r in reflections) {
      dev.log(r.toString(), name: 'ReflectionDump');
    }

    final jsonString = await HiveService.exportToJson();
    dev.log('📦 Exported Reflections:\n$jsonString', name: 'ReflectionExport');
  }

  runApp(const ProviderScope(child: HumbleApp()));
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cleanMalformedReflections();
  await VoiceService.init();
  debugPrint('VoiceService initialized with TTS settings');

  await Hive.initFlutter();

  // ✅ Register ActualsEntry adapter
  Hive.registerAdapter(ActualsEntryAdapter());
  await Hive.openBox<ActualsEntry>('actualsEntries');

  // ✅ Register BlockReflection adapter (already present)
  await HiveService.init();

  // ✅ Load persisted actuals into store
  await ActualsStore.instance.init();

  if (!kReleaseMode) {
    final reflections = HiveService.getAllReflections();
    for (final r in reflections) {
      dev.log(r.toString(), name: 'ReflectionDump');
    }

    final jsonString = await HiveService.exportToJson();
    dev.log('📦 Exported Reflections:\n$jsonString', name: 'ReflectionExport');
  }

  runApp(const ProviderScope(child: HumbleApp()));
}

class HumbleApp extends ConsumerWidget {
  const HumbleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final settings = ref.watch(userSettingsProvider).settings;

    // 🔁 Sync TTS language with current locale
    VoiceService.updateLanguageFromLocale(locale);

    return MaterialApp.router(
      title: 'Humble Time Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themedLight(settings.colorPalette),
      darkTheme: AppTheme.themedDark(settings.colorPalette),
      themeMode: settings.preferredBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
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
            const VoiceInitializer(),
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
    Future.microtask(() async {
      if (!mounted) return;

      final locale = Localizations.localeOf(context); // ✅ Extract Locale
      final startupPrompt = await PromptLibrary.forEvent('startBlock', locale); // ✅ Await async call

      debugPrint('VoiceInitializer: Startup prompt — "$startupPrompt"');
      VoiceService.speak(startupPrompt); // ✅ Pass resolved String
    });
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Voice initializer for startup prompt',
    child: const SizedBox.shrink(),
  );
}

