import 'package:flutter/material.dart';
import 'package:humble_time_app/models/time_block.dart';

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

  @override
  Widget build(BuildContext context) {
    final isBreak = taskType == TaskType.breakBlock;

    final blockColor = isBreak ? Colors.orange[100] : Colors.green[100];
    final icon = isBreak ? Icons.coffee : Icons.work;
    final trailingIcon = isBreak
        ? Icons.self_improvement
        : Icons.track_changes;

    return Card(
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
        trailing: Icon(trailingIcon, color: isBreak ? Colors.deepOrange : Colors.green[700]),
      ),
    );
  }
}
