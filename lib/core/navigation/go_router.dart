import 'package:go_router/go_router.dart';
import 'package:humble_time_app/core/navigation/app_shell.dart';

// Feature screens
import 'package:humble_time_app/features/home/home_screen.dart';
import 'package:humble_time_app/features/log/log_screen.dart';
import 'package:humble_time_app/features/actuals/actuals_screen.dart';
import 'package:humble_time_app/features/scheduler/scheduler_screen.dart';
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
import 'package:humble_time_app/features/session/reflection_history_screen.dart';

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


    // 🧱 Shell layout routes (share AppShell + BottomNavBar)
    ShellRoute(
      builder: (context, state, child) {
        final showBackArrow = state.uri.path == '/journal-review';
        final screenTitle = {
          '/journal-review': 'Journal Review',
          '/journal': 'Journal',
          '/schedule': 'Schedule',
          '/mood': 'Mood',
          '/settings': 'Settings',
          '/pacing': 'Pacing',
          '/reflection-history': 'Reflection History',
          '/': 'Home',
        }[state.uri.path];

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
      ],
    ),
  ],
);
