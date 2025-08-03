import 'package:flutter/material.dart';
import 'package:humble_time_app/models/log_entry.dart';

class LogTile extends StatelessWidget {
  final LogEntry entry;

  const LogTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final blockColor = switch (entry.blockType) {
      LogBlockType.focusBlock => Colors.indigo.shade100,
      LogBlockType.breakBlock => Colors.green.shade100,
      LogBlockType.defaultBlock => Colors.grey.shade200,
      LogBlockType.meditation => Colors.purple.shade100,
      LogBlockType.other => Colors.orange.shade100,
    };

    final voiceIcon = entry.usedVoicePrompts
        ? const Icon(Icons.volume_up, size: 20, color: Colors.black54)
        : const SizedBox(width: 20);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      color: blockColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(entry.readableType,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${_formatTime(entry.startTime)} – ${_formatTime(entry.endTime)}  •  ${entry.formattedDuration}',
          style: const TextStyle(fontSize: 14.0),
        ),
        trailing: voiceIcon,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
