import 'package:flutter/widgets.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';

class MoodResolver {
  static final Map<String, String> _emojiToKey = {
    '🙂': 'happy',
    '😐': 'neutral',
    '😕': 'confused',
    '😢': 'sad',
    '😄': 'joyful',
  };

  static final Map<String, String> _keyToEmoji = {
    'happy': '🙂',
    'neutral': '😐',
    'confused': '😕',
    'sad': '😢',
    'joyful': '😄',
  };

  /// Returns the mood key for a given emoji
  static String? keyFromEmoji(String emoji) => _emojiToKey[emoji];

  /// Returns the emoji for a given mood key
  static String? emojiFromKey(String key) => _keyToEmoji[key];

  /// Returns the localized label for a mood key
  static String localizedLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'happy':
        return l10n.moodHappy;
      case 'neutral':
        return l10n.moodNeutral;
      case 'confused':
        return l10n.moodConfused;
      case 'sad':
        return l10n.moodSad;
      case 'joyful':
        return l10n.moodJoyful; // Either 'Grinning', otherwise use moodJoyful
      default:
        return key;
    }
  }

  /// Returns the emoji + localized label (e.g., 🙂 Happy)
  static String emojiWithLabel(BuildContext context, String key) {
    final emoji = emojiFromKey(key) ?? '';
    final label = localizedLabel(context, key);
    return '$emoji $label';
  }
}
