import 'package:flutter/material.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:intl/intl.dart';

class LogDetailScreen extends StatelessWidget {
  final LogEntry entry;

  const LogDetailScreen({super.key, required this.entry});

  String format(DateTime dt) => DateFormat('yyyy-MM-dd HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.readableType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Start: ${format(entry.startTime)}'),
            Text('End: ${format(entry.endTime)}'),
            Text('Duration: ${entry.formattedDuration}'),
            const SizedBox(height: 12),
            Text('Voice Prompt: ${entry.usedVoicePrompts ? "Used 🎙️" : "Silent 🔇"}'),
            if (entry.note != null) ...[
              const SizedBox(height: 12),
              Text('Note: ${entry.note}'),
            ],
            if (entry.tags != null && entry.tags!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: entry.tags!.map((t) => Chip(label: Text(t))).toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
