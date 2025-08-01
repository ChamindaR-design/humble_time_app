import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  void _handleTabChange(BuildContext context, String route) {
    GoRouter.of(context).go(route);
    VoiceService.speak(PromptLibrary.forRoute(route));
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context)
        .routeInformationProvider
        .value
        .uri
        .path;

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(location),
      onTap: (index) {
        final route = _getRouteForIndex(index);
        _handleTabChange(context, route);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: 'Mood'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Journal'), // 🔄 Icon updated!
      ],
      type: BottomNavigationBarType.fixed,
    );
  }

  int _getCurrentIndex(String location) {
    final normalized = location.replaceAll(RegExp(r'/+$'), '');

    return {
      '/': 0,
      '/schedule': 1,
      '/mood': 2,
      '/settings': 3,
      '/journal': 4,
    }[normalized] ?? 0;
  }

  String _getRouteForIndex(int index) {
    return [
      '/',
      '/schedule',
      '/mood',
      '/settings',
      '/journal',
    ][index];
  }
}
