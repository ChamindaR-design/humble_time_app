import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/models/time_log_entry.dart';

class LogHistoryWidget extends StatelessWidget {
  final List<TimeLogEntry> entries;
  final FlutterTts tts;

  const LogHistoryWidget({
    required this.entries,
    required this.tts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(entry.description),
              subtitle: Text(
                '${DateFormat.yMMMd().add_jm().format(entry.startTime)} - ${DateFormat.jm().format(entry.endTime)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () {
                  tts.speak(entry.description);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
