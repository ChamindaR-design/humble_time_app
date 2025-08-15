import 'package:flutter/material.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/models/task_type.dart';
import 'package:humble_time_app/widgets/narrated_text.dart';

class NarratedBlockTile extends StatelessWidget {
  final TimeBlock block;
  final int index;
  final VoidCallback? onTap;

  const NarratedBlockTile({
    super.key,
    required this.block,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = _getLabelForType(block.taskType);
    final durationText = '${block.duration.inMinutes} minutes';

    return Semantics(
      label: '$label block, $durationText',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 88, // Increased height for breathing room
          width: 82,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300 + index * 50),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: _getColorForType(block.taskType, context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getEmojiForType(block.taskType),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                NarratedText(
                  text: label,
                  speakOnBuild: false,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                NarratedText(
                  text: durationText,
                  speakOnBuild: false,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForType(TaskType type, BuildContext context) {
    switch (type) {
      case TaskType.focusBlock:
        return Theme.of(context).colorScheme.primaryContainer;
      case TaskType.breakBlock:
        return Theme.of(context).colorScheme.secondaryContainer;
      case TaskType.meditation:
        return Theme.of(context).colorScheme.tertiaryContainer;
      case TaskType.other:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  String _getEmojiForType(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return '🎯';
      case TaskType.breakBlock:
        return '☕';
      case TaskType.meditation:
        return '🧘';
      case TaskType.other:
        return '🔧';
    }
  }

  String _getLabelForType(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return 'Focus';
      case TaskType.breakBlock:
        return 'Break';
      case TaskType.meditation:
        return 'Meditation';
      case TaskType.other:
        return 'Other';
    }
  }
}
