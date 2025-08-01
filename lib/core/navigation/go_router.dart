import 'package:go_router/go_router.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';

// Feature screens
import 'package:humble_time_app/features/home/home_screen.dart';
import 'package:humble_time_app/features/log/log_screen.dart';
import 'package:humble_time_app/features/scheduler/scheduler_screen.dart';
import 'package:humble_time_app/features/settings/settings_screen.dart';
import 'package:humble_time_app/features/pacing/pacing_screen.dart';
import 'package:humble_time_app/features/actuals/actuals_screen.dart';
import 'package:humble_time_app/features/mood/mood_screen.dart';
import 'package:humble_time_app/features/planner/time_mosaic_screen.dart';
import 'package:humble_time_app/features/schedule/schedule_screen.dart';

import 'package:humble_time_app/features/journal/journal_review_screen.dart';
import 'package:humble_time_app/features/journal/journal_main_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // 📦 Full-screen routes outside the BottomNav shell
    GoRoute(
      path: '/log',
      builder: (_, __) => const LogScreen(),
    ),
    GoRoute(
      path: '/actuals',
      builder: (_, __) => const ActualsScreen(),
    ),
    GoRoute(
      path: '/pacing',
      builder: (_, __) => const PacingScreen(),
    ),
    GoRoute(
      path: '/scheduler',
      builder: (_, __) => const SchedulerScreen(),
    ),
    GoRoute(
      path: '/time-mosaic-planner',
      builder: (_, __) => const TimeMosaicScreen(),
    ),
    GoRoute(
      path: '/journal-review',
      builder: (_, __) => const JournalReviewScreen(),
    ),

    // 🧱 Shell layout routes (use shared AppShell + BottomNav)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/schedule',
          builder: (_, __) => const ScheduleScreen(),
        ),
        GoRoute(
          path: '/mood',
          builder: (_, __) => const MoodScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/journal',
          builder: (_, __) => const JournalMainScreen(),
        ),
      ],
    ),
  ],
);
