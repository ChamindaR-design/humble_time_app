import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/core/navigation/bottom_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBackButton;

  const AppShell({
    required this.child,
    this.title,
    this.showBackButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/journal'),
                      tooltip: 'Go back',
                    )
                  : null,
            )
          : null,
      body: SafeArea(child: child),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
