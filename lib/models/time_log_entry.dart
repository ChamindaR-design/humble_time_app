//import 'package:flutter_tts/flutter_tts.dart';

class TimeLogEntry {
  final DateTime startTime;
  final DateTime endTime;
  final String description;

  TimeLogEntry({
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  Duration get duration => endTime.difference(startTime);

  @override
  String toString() {
    return '$description (${startTime.toIso8601String()} - ${endTime.toIso8601String()})';
  }
}
