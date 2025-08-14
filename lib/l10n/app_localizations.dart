import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('si'),
  ];

  /// Title for a focus block section
  ///
  /// In en, this message translates to:
  /// **'Focus Block'**
  String get focusBlockTitle;

  /// Title for a break block section
  ///
  /// In en, this message translates to:
  /// **'Break Block'**
  String get breakBlockTitle;

  /// Title for the time mosaic planner screen
  ///
  /// In en, this message translates to:
  /// **'Time Mosaic Planner'**
  String get timeMosaicPlanner;

  /// App title displayed in the UI
  ///
  /// In en, this message translates to:
  /// **'Humble Time Tracker'**
  String get appTitle;

  /// Label for the log history screen
  ///
  /// In en, this message translates to:
  /// **'Log History'**
  String get logHistory;

  /// Label for actual time usage screen
  ///
  /// In en, this message translates to:
  /// **'Actuals'**
  String get actuals;

  /// Label for pacing screen
  ///
  /// In en, this message translates to:
  /// **'Pacing'**
  String get pacing;

  /// Label for scheduler screen
  ///
  /// In en, this message translates to:
  /// **'Scheduler'**
  String get scheduler;

  /// Label for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for journal review screen
  ///
  /// In en, this message translates to:
  /// **'Journal Review'**
  String get journalReview;

  /// Label for reflection history screen
  ///
  /// In en, this message translates to:
  /// **'Reflection History'**
  String get reflectionHistory;

  /// Voice confirmation when language is changed
  ///
  /// In en, this message translates to:
  /// **'Language switched to English'**
  String get languageSwitched;

  /// Voice prompt when a focus block begins. Encouraging and grounding tone.
  ///
  /// In en, this message translates to:
  /// **'Block started. Let’s stay present and keep pacing yourself.'**
  String get voiceFocusStart;

  /// Voice prompt when a focus block is completed. Affirming and reflective tone.
  ///
  /// In en, this message translates to:
  /// **'Well done. That was focused time well spent. Want to log how it felt?'**
  String get voiceFocusComplete;

  /// Voice prompt when idle time is detected. Curious and supportive tone.
  ///
  /// In en, this message translates to:
  /// **'Looks like there’s been a gap. Shall we restart your block or save progress?'**
  String get voiceIdleDetected;

  /// Voice prompt when a break block begins. Light and inviting tone.
  ///
  /// In en, this message translates to:
  /// **'Time for a break'**
  String get voiceBreakStart;

  /// Voice prompt asking for current mood. Gentle and open tone.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now?'**
  String get voiceMoodPrompt;

  /// Voice confirmation after mood is saved. Reassuring and smooth transition.
  ///
  /// In en, this message translates to:
  /// **'Mood saved. Let’s continue.'**
  String get voiceMoodSaved;

  /// Voice confirmation after mood is selected. Adaptive and affirming tone.
  ///
  /// In en, this message translates to:
  /// **'Mood {mood} selected. Let\'s continue.'**
  String voiceMoodSelected(String mood);

  /// Voice prompt when user returns to the app. Warm and motivating tone.
  ///
  /// In en, this message translates to:
  /// **'Welcome back. Ready to build your next focus block?'**
  String get voiceWelcomeBack;

  /// Voice prompt when user exits a session. Friendly and considerate tone.
  ///
  /// In en, this message translates to:
  /// **'Leaving so soon? Want to save this session before you head out?'**
  String get voiceLeavingSession;

  /// Generic fallback voice prompt. Neutral and forward-moving tone.
  ///
  /// In en, this message translates to:
  /// **'Let\'s keep going.'**
  String get voiceGenericFallback;

  /// Label for mood selection
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// Mood label: Happy (positive emotional state)
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// Mood label: Neutral (emotionally steady or indifferent)
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// Mood label: Sad (low emotional state)
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// Mood label: Crying (intense sadness or emotional release)
  ///
  /// In en, this message translates to:
  /// **'Crying'**
  String get moodCrying;

  /// Mood label: Joyful (expressive happiness and delight)
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get moodJoyful;

  /// Mood label: Angry (frustration or irritation)
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get moodAngry;

  /// Mood label: Surprised (unexpected reaction or shock)
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get moodSurprised;

  /// Mood label: Confused (uncertainty or lack of clarity)
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get moodConfused;

  /// Mood label: Sleepy (low energy or drowsiness)
  ///
  /// In en, this message translates to:
  /// **'Sleepy'**
  String get moodSleepy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
