class PromptLibrary {
  /// Returns a voice prompt string based on the route path.
  static String forRoute(String route) {
    switch (route) {
      case '/':
        return 'Welcome home. Let’s begin tracking.';
      case '/schedule':
        return 'Opening your schedule overview.';
      case '/mood':
        return 'Let’s reflect on how you’re feeling.';
      case '/settings':
        return 'Adjusting your preferences.';
      default:
        return 'Navigating to a new section.';
    }
  }

  /// Returns a voice prompt string based on the event key and optional parameter.
  static String forEvent(String eventKey, {String? param}) {
    switch (eventKey) {
      case 'startBlock':
        return "Block started. Let’s stay present and keep pacing yourself";

      case 'completeBlock':
        return "Well done. That was focused time well spent. Want to log how it felt?";

      case 'idleDetected':
        return "Looks like there’s been a gap. Shall we restart your block or save progress?";

      case 'moodPrompt':
        return "How are you feeling right now?";

      case 'moodSaved':
        return "Mood saved. Let’s continue.";

      case 'moodSelected':
        return "Mood ${param ?? 'Unknown'} selected. Let's continue.";

      case 'welcomeBack':
        return "Welcome back. Ready to build your next focus block?";

      case 'leavingSession':
        return "Leaving so soon? Want to save this session before you head out?";

      default:
        return "Let's keep going.";
    }
  }
}


