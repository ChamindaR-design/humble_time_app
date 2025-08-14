import 'package:flutter/material.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';

enum VoiceTone {
  calm,
  affirming,
  gentle,
  curious,
  neutral,
  warm,
  concerned,
}

class PromptLibrary {
  static String forRoute(String route) {
    final normalized = _normalizeRoute(route);

    switch (normalized) {
      case '/':
        return 'Welcome home. Let’s begin tracking.';
      case '/schedule':
        return 'Opening your schedule overview.';
      case '/mood':
        return 'Let’s reflect on how you’re feeling.';
      case '/settings':
        return 'Adjusting your preferences.';
      case '/journal':
        return 'Opening your journal. Let’s reflect on your progress.';
      case '/journal-review':
        return 'Reviewing your journal entries.';
      case '/reflection-history':
        return 'Here’s your reflection history. Notice any patterns?';
      case '/actuals':
        return 'Reviewing your actuals. Let’s see how your time was spent.';
      case '/scheduler':
        return 'Planning ahead. Let’s shape your day intentionally.';
      case '/time-mosaic-planner':
        return 'Let’s build your day block by block.';
      case '/pacing':
        return 'Let’s check your pacing and stay on track.';
      default:
        return 'Navigating to a new section.';
    }
  }

  /// Returns a localized voice prompt string and tone tag based on the event key.
  static Future<Map<String, dynamic>> forEventWithTone(
      String eventKey, Locale locale,
      {String? param}) async {
    final l10n = await AppLocalizations.delegate.load(locale);

    switch (eventKey) {
      case 'startBlock':
        return {'text': l10n.voiceFocusStart, 'tone': VoiceTone.calm};
      case 'completeBlock':
        return {'text': l10n.voiceFocusComplete, 'tone': VoiceTone.affirming};
      case 'idleDetected':
        return {'text': l10n.voiceIdleDetected, 'tone': VoiceTone.gentle};
      case 'moodPrompt':
        return {'text': l10n.voiceMoodPrompt, 'tone': VoiceTone.curious};
      case 'moodSaved':
        return {'text': l10n.voiceMoodSaved, 'tone': VoiceTone.neutral};
      case 'moodSelected':
        return {
          'text': l10n.voiceMoodSelected(param ?? 'Unknown'),
          'tone': VoiceTone.neutral
        };
      case 'welcomeBack':
        return {'text': l10n.voiceWelcomeBack, 'tone': VoiceTone.warm};
      case 'leavingSession':
        return {'text': l10n.voiceLeavingSession, 'tone': VoiceTone.concerned};
      default:
        return {'text': l10n.voiceGenericFallback, 'tone': VoiceTone.neutral};
    }
  }

  /// Returns only the localized voice prompt string (no tone).
  static Future<String> forEvent(String eventKey, Locale locale,
      {String? param}) async {
    final result = await forEventWithTone(eventKey, locale, param: param);
    return result['text'] as String;
  }

  static String _normalizeRoute(String route) {
    final path = route.split('?').first;
    final segments = path.split('/');
    if (segments.length > 2) {
      return '/${segments[1]}';
    }
    return path;
  }
}
