import 'package:flutter/material.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/log/log_detail_screen.dart';
import 'package:intl/intl.dart';

class LogTile extends StatelessWidget {
  final LogEntry entry;

  const LogTile({super.key, required this.entry});

  String get formattedTime {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(entry.startTime)} - ${formatter.format(entry.endTime)}';
  }

  IconData get blockIcon {
    switch (entry.blockType) {
      case LogBlockType.focusBlock:
        return Icons.work;
      case LogBlockType.breakBlock:
        return Icons.nature_people;
      case LogBlockType.meditation:
        return Icons.self_improvement;
      case LogBlockType.defaultBlock:
        return Icons.lightbulb;
      case LogBlockType.other:
        return Icons.timeline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usedVoice = entry.usedVoicePrompts ? '🎙️ voice used' : '🔇 silent';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LogDetailScreen(entry: entry),
            ),
          );
        },
        leading: Icon(blockIcon, size: 32),
        title: Text(formattedTime),
        subtitle: Text('${entry.note ?? "No notes"}\n$usedVoice'),
        isThreeLine: true,
        trailing: entry.tags != null && entry.tags!.isNotEmpty
            ? Wrap(
                spacing: 4,
                children: entry.tags!.map((tag) => Chip(label: Text(tag))).toList(),
              )
            : null,
      ),
    );
  }
}
