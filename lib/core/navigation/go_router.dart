import 'package:go_router/go_router.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';

// Feature screens
import 'package:humble_time_app/features/home/home_screen.dart';
import 'package:humble_time_app/features/log/log_screen.dart';
import 'package:humble_time_app/features/actuals/actuals_screen.dart';
import 'package:humble_time_app/features/scheduler/screens/scheduler_screen.dart';
import 'package:humble_time_app/features/planner/time_mosaic_screen.dart';

// Shell-wrapped screens
import 'package:humble_time_app/features/schedule/schedule_screen.dart';
import 'package:humble_time_app/features/mood/mood_screen.dart';
import 'package:humble_time_app/features/settings/settings_screen.dart';
import 'package:humble_time_app/features/pacing/pacing_screen.dart';

// Journal screens (using import aliases)
import 'package:humble_time_app/features/journal/journal_main_screen.dart' as main;
import 'package:humble_time_app/features/journal/journal_review_screen.dart' as review;

// Reflection history screen
import 'package:humble_time_app/features/reflection/screens/reflection_history_screen.dart';

import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:flutter/material.dart';

// Scheduler Screen
import 'package:humble_time_app/features/scheduler/screens/block_session_screen.dart';
import 'package:humble_time_app/models/time_block.dart';

// Reflection Screens
import 'package:humble_time_app/features/session/session_reflection_screen.dart';
import 'package:humble_time_app/models/log_entry.dart';



final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // 💬 Fullscreen routes (no BottomNavBar)
    GoRoute(
      path: '/log',
      builder: (_, _) => const LogScreen(),
    ),
    GoRoute(
      path: '/actuals',
      builder: (_, _) => const ActualsScreen(),
    ),
    GoRoute(
      path: '/scheduler',
      builder: (_, _) => const SchedulerScreen(),
    ),
    GoRoute(
      path: '/time-mosaic-planner',
      builder: (_, _) => const TimeMosaicScreen(),
    ),
/*    GoRoute(
      path: '/reflection-history',
      name: 'reflectionHistory',
      builder: (_, _) => const ReflectionHistoryScreen(),
    ),*/
    GoRoute(
      path: '/session',
      builder: (context, state) {
        /*final block = state.extra as TimeBlock;
        return BlockSessionScreen(block: block);*/
        final block = state.extra;
        if (block is! TimeBlock) {
          throw Exception('Expected TimeBlock in /session route');
        }
        return BlockSessionScreen(block: block);
      },
    ),
    /*GoRoute(
      name: 'reflection',
      path: '/reflection',
      builder: (context, state) {
        final entry = state.extra;
        if (entry is! LogEntry) {
          throw Exception('Expected LogEntry in /reflection route');
        }
        return SessionReflectionScreen(entry: entry);
      },
    ),*/
    GoRoute(
      name: 'reflection',
      path: '/reflection',
      builder: (context, state) {
        final entry = state.extra;
        if (entry is! LogEntry) {
          debugPrint('⚠️ /reflection triggered without LogEntry. Showing fallback.');
          return Scaffold(
            appBar: AppBar(title: const Text('Reflection')),
            body: const Center(
              child: Text(
                'No session data found.\nPlease select a log entry first.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SessionReflectionScreen(entry: entry);
      },
    ),

    // 🧱 Shell layout routes (share AppShell + BottomNavBar)
    ShellRoute(
      builder: (context, state, child) {
        final currentPath = state.uri.path;

        final showBackArrow = currentPath == '/journal-review';

        final screenTitle = {
          '/journal-review': 'Journal Review',
          '/journal': 'Journal',
          '/schedule': 'Schedule',
          '/mood': 'Mood',
          '/settings': 'Settings',
          '/pacing': 'Pacing',
          '/reflection-history': 'Reflection History',
          '/actuals': 'Actuals',
          '/scheduler': 'Scheduler',
          '/time-mosaic-planner': 'Planner',
          '/': 'Home',
        }[currentPath];

        // 🔊 Trigger voice prompt based on route
        Future.microtask(() {
          final prompt = PromptLibrary.forRoute(currentPath);
          debugPrint('Voice prompt for route: $currentPath → "$prompt"');
          VoiceService.speak(prompt);
        });

        return AppShell(
          title: screenTitle,
          showBackButton: showBackArrow,
          child: child,
        );
      },
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/schedule', builder: (_, _) => const ScheduleScreen()),
        GoRoute(path: '/mood', builder: (_, _) => const MoodScreen()),
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        GoRoute(path: '/journal', builder: (_, _) => const main.JournalMainScreen()),
        GoRoute(path: '/journal-review', builder: (_, _) => const review.JournalReviewScreen()),
        GoRoute(path: '/pacing', builder: (_, _) => const PacingScreen()),
        GoRoute(path: '/reflection-history', builder: (_, _) => const ReflectionHistoryScreen()),
        GoRoute(path: '/actuals', builder: (_, _) => const ActualsScreen()),
        GoRoute(path: '/scheduler', builder: (_, _) => const SchedulerScreen()),
        GoRoute(path: '/time-mosaic-planner', builder: (_, _) => const TimeMosaicScreen()),
      ],
    ),
  ],
);
