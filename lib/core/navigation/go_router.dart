import 'package:humble_time_app/features/log/log_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/features/home/home_screen.dart';
import 'package:humble_time_app/features/scheduler/scheduler_screen.dart';
import 'package:humble_time_app/features/settings/settings_screen.dart';
import 'package:humble_time_app/features/pacing/pacing_screen.dart';
import 'package:humble_time_app/features/actuals/actuals_screen.dart';
import 'package:humble_time_app/features/mood/mood_screen.dart';
import 'package:humble_time_app/features/planner/time_mosaic_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
    ),
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
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/mood',
      builder: (_, __) => const MoodScreen(),
    ),
    GoRoute(
      path: '/time-mosaic-planner',
      builder: (_, __) => const TimeMosaicScreen(),
    ),        
  ],
);
