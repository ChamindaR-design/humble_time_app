// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get focusBlockTitle => 'Focus Block';

  @override
  String get breakBlockTitle => 'Break Block';

  @override
  String get timeMosaicPlanner => 'Time Mosaic Planner';

  @override
  String get appTitle => 'Humble Time Tracker';

  @override
  String get logHistory => 'Log History';

  @override
  String get actuals => 'Actuals';

  @override
  String get pacing => 'Pacing';

  @override
  String get scheduler => 'Scheduler';

  @override
  String get settings => 'Settings';

  @override
  String get journalReview => 'Journal Review';

  @override
  String get reflectionHistory => 'Reflection History';

  @override
  String get languageSwitched => 'Language switched to English';

  @override
  String get voiceFocusStart =>
      'Block started. Let’s stay present and keep pacing yourself.';

  @override
  String get voiceFocusComplete =>
      'Well done. That was focused time well spent. Want to log how it felt?';

  @override
  String get voiceIdleDetected =>
      'Looks like there’s been a gap. Shall we restart your block or save progress?';

  @override
  String get voiceBreakStart => 'Time for a break';

  @override
  String get voiceMoodPrompt => 'How are you feeling right now?';

  @override
  String get voiceMoodSaved => 'Mood saved. Let’s continue.';

  @override
  String voiceMoodSelected(String mood) {
    return 'Mood $mood selected. Let\'s continue.';
  }

  @override
  String get voiceWelcomeBack =>
      'Welcome back. Ready to build your next focus block?';

  @override
  String get voiceLeavingSession =>
      'Leaving so soon? Want to save this session before you head out?';

  @override
  String get voiceGenericFallback => 'Let\'s keep going.';

  @override
  String get mood => 'Mood';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodCrying => 'Crying';

  @override
  String get moodJoyful => 'Joyful';

  @override
  String get moodAngry => 'Angry';

  @override
  String get moodSurprised => 'Surprised';

  @override
  String get moodConfused => 'Confused';

  @override
  String get moodSleepy => 'Sleepy';
}
