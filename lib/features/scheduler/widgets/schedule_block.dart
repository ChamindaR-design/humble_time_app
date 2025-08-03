import 'package:flutter/material.dart';
import 'package:humble_time_app/models/task_type.dart';

class ScheduleBlock extends StatelessWidget {
  final String title;
  final Duration duration;
  final TaskType taskType;

  const ScheduleBlock({
    required this.title,
    required this.duration,
    required this.taskType,
    super.key,
  });

  Color? getBlockColor(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return Colors.green[100];
      case TaskType.breakBlock:
        return Colors.orange[100];
      case TaskType.meditation:
        return Colors.purple[100];
      case TaskType.other:
        return Colors.blueGrey[100];
    }
  }

  IconData getBlockIcon(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return Icons.work;
      case TaskType.breakBlock:
        return Icons.coffee;
      case TaskType.meditation:
        return Icons.self_improvement;
      case TaskType.other:
        return Icons.track_changes;
    }
  }

  IconData getTrailingIcon(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return Icons.check_circle;
      case TaskType.breakBlock:
        return Icons.bedtime;
      case TaskType.meditation:
        return Icons.spa;
      case TaskType.other:
        return Icons.explore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final blockColor = getBlockColor(taskType);
    final icon = getBlockIcon(taskType);
    final trailingIcon = getTrailingIcon(taskType);

    return Semantics(
      label: '${taskType.name} block: $title',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: blockColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '${duration.inMinutes} minute${duration.inMinutes != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          trailing: Icon(trailingIcon, color: Colors.teal),
        ),
      ),
    );
  }
}
