import 'package:flutter/widgets.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';

/// Enum representing supported mood keys for localization and voice synthesis.
enum MoodKey {
  happy,
  neutral,
  sad,
  crying,
  grinning,
  angry,
  surprised,
  confused,
  sleepy,
}

/// Resolves localized mood label from a [MoodKey] using the current [BuildContext].
String localizedMoodLabelFromEnum(BuildContext context, MoodKey mood) {
  final loc = AppLocalizations.of(context)!;

  return switch (mood) {
    MoodKey.happy => loc.moodHappy,
    MoodKey.neutral => loc.moodNeutral,
    MoodKey.sad => loc.moodSad,
    MoodKey.crying => loc.moodCrying,
    MoodKey.grinning => loc.moodJoyful,
    MoodKey.angry => loc.moodAngry,
    MoodKey.surprised => loc.moodSurprised,
    MoodKey.confused => loc.moodConfused,
    MoodKey.sleepy => loc.moodSleepy,
  };
}
