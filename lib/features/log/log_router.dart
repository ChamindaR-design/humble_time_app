import 'package:flutter/material.dart';
import 'package:humble_time_app/features/log/log_screen.dart';
// Placeholder for future route:
// import 'package:humble_time_app/features/log/log_detail_screen.dart';

class LogRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/logs':
        return MaterialPageRoute(builder: (_) => const LogScreen());
      // case '/logs/detail':
      //   final logEntry = settings.arguments as LogEntry;
      //   return MaterialPageRoute(builder: (_) => LogDetailScreen(entry: logEntry));
    }

    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Unknown log route')),
      ),
    );
  }
}
