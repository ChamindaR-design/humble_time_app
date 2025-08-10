class PromptLibrary {
  /// Returns a voice prompt string based on the route path.
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

  /// Returns a voice prompt string and tone tag based on the event key.
  static Map<String, String> forEventWithTone(String eventKey, {String? param}) {
    switch (eventKey) {
      case 'startBlock':
        return {
          'text': "Block started. Let’s stay present and keep pacing yourself.",
          'tone': 'calm',
        };

      case 'completeBlock':
        return {
          'text': "Well done. That was focused time well spent. Want to log how it felt?",
          'tone': 'affirming',
        };

      case 'idleDetected':
        return {
          'text': "Looks like there’s been a gap. Shall we restart your block or save progress?",
          'tone': 'gentle',
        };

      case 'moodPrompt':
        return {
          'text': "How are you feeling right now?",
          'tone': 'curious',
        };

      case 'moodSaved':
        return {
          'text': "Mood saved. Let’s continue.",
          'tone': 'neutral',
        };

      case 'moodSelected':
        return {
          'text': "Mood ${param ?? 'Unknown'} selected. Let's continue.",
          'tone': 'neutral',
        };

      case 'welcomeBack':
        return {
          'text': "Welcome back. Ready to build your next focus block?",
          'tone': 'warm',
        };

      case 'leavingSession':
        return {
          'text': "Leaving so soon? Want to save this session before you head out?",
          'tone': 'concerned',
        };

      default:
        return {
          'text': "Let's keep going.",
          'tone': 'neutral',
        };
    }
  }

  /// Simple fallback for legacy use
  static String forEvent(String eventKey, {String? param}) =>
      forEventWithTone(eventKey, param: param)['text'] ?? "Let's keep going.";

  /// Normalizes route by stripping query params and limiting depth
  static String _normalizeRoute(String route) {
    final path = route.split('?').first;
    final segments = path.split('/');
    if (segments.length > 2) {
      return '/${segments[1]}'; // e.g. /journal/123 → /journal
    }
    return path;
  }
}
