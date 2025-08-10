import 'package:flutter/material.dart';

class BlockTimerOverlay extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isRunning;

  const BlockTimerOverlay({
    super.key,
    required this.progress,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();

    return Semantics(
      label: 'Focus timer progress: $percent percent',
      child: Tooltip(
        message: isRunning ? 'Timer running: $percent%' : 'Block complete',
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isRunning ? Colors.teal : Colors.grey,
                    ),
                  );
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isRunning ? Icons.timer : Icons.check_circle,
                key: ValueKey<bool>(isRunning),
                size: 20,
                color: isRunning ? Colors.teal : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
