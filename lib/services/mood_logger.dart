import 'dart:developer' as dev;

class MoodLogger {
  static void saveMood(String moodLabel) {
    dev.log('Mood logged: $moodLabel', name: 'MoodLogger');
  }
}

