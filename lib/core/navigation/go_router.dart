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

// ✅ Use import prefixes to resolve duplicate class names
import 'package:humble_time_app/features/journal/journal_review_screen.dart' as review;
import 'package:humble_time_app/features/journal/journal_main_screen.dart' as main;

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // 📦 Full-screen routes outside the BottomNav shell
    GoRoute(
      path: '/log',
      builder: (_, _) => const LogScreen(),
    ),
    GoRoute(
      path: '/actuals',
      builder: (_, _) => const ActualsScreen(),
    ),
    GoRoute(
      path: '/pacing',
      builder: (_, _) => const PacingScreen(),
    ),
    GoRoute(
      path: '/scheduler',
      builder: (_, _) => const SchedulerScreen(),
    ),
    GoRoute(
      path: '/time-mosaic-planner',
      builder: (_, _) => const TimeMosaicScreen(),
    ),
    GoRoute(
      path: '/journal-review',
      builder: (_, _) => const review.JournalReviewScreen(),
    ),

    // 🧱 Shell layout routes (use shared AppShell + BottomNav)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const HomeScreen(),
        ),
        GoRoute(
          path: '/schedule',
          builder: (_, _) => const ScheduleScreen(),
        ),
        GoRoute(
          path: '/mood',
          builder: (_, _) => const MoodScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, _) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/journal',
          builder: (_, _) => const main.JournalMainScreen(),
        ),
      ],
    ),
  ],
);
