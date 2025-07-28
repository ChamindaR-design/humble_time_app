import 'package:flutter/material.dart';
import 'package:humble_time_app/core/navigation/bottom_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
