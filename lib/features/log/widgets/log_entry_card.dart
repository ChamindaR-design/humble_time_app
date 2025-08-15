import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogEntryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final VoidCallback? onTap;
  final VoidCallback? onPlayVoice;

  const LogEntryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.onTap,
    this.onPlayVoice,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = '${timestamp.day}/${timestamp.month}/${timestamp.year}';

    return Semantics(
      label: 'Log entry: $title, recorded on $formattedDate',
      button: true,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDate,
                        style: Theme.of(context).textTheme.labelSmall),
                    if (onPlayVoice != null)
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Play voice reflection',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onPlayVoice?.call();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
