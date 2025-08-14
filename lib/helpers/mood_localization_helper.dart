import 'package:flutter/material.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';
import 'dart:developer' as dev;

String localizedMoodLabel(BuildContext context, String moodKey) {
  final loc = AppLocalizations.of(context)!;

  return switch (moodKey.toLowerCase()) {
    'happy' => loc.moodHappy,
    'neutral' => loc.moodNeutral,
    'sad' => loc.moodSad,
    'crying' => loc.moodCrying,
    'grinning' => loc.moodJoyful,
    'angry' => loc.moodAngry,
    'surprised' => loc.moodSurprised,
    'confused' => loc.moodConfused,
    'sleepy' => loc.moodSleepy,
    _ => () {
      dev.log('⚠️ Unknown moodKey: "$moodKey"', name: 'localizedMoodLabel');
      return moodKey;
    }(),
  };
}

