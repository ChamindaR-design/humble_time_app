// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get focusBlockTitle => 'ලක්ෂ්‍ය කාලය';

  @override
  String get breakBlockTitle => 'විවේක කාලය';

  @override
  String get timeMosaicPlanner => 'කාල මෝසැක් සැලසුම්කරු';

  @override
  String get appTitle => 'Humble Time Tracker';

  @override
  String get logHistory => 'ලඝු ඉතිහාසය';

  @override
  String get actuals => 'සත්‍ය වාර්තා';

  @override
  String get pacing => 'වේග සැලසුම';

  @override
  String get scheduler => 'කාලසටහන් සකස්කරු';

  @override
  String get settings => 'සැකසුම්';

  @override
  String get journalReview => 'දායක සමාලෝචනය';

  @override
  String get reflectionHistory => 'පැහැදිලි කිරීමේ ඉතිහාසය';

  @override
  String get languageSwitched => 'භාෂාව සිංහලට මාරු විය';

  @override
  String get voiceFocusStart =>
      'ලක්ෂ්‍ය කාලය ආරම්භ විය. දැන් පැහැදිලිව සිටින්න.';

  @override
  String get voiceFocusComplete =>
      'ඔබ හොඳින් කටයුතු කළා. ලක්ෂ්‍ය කාලය සුරකින්නද?';

  @override
  String get voiceIdleDetected =>
      'ඔබ තාවකාලිකව නවතා ඇත. නැවත ආරම්භ කරන්නද නැත්නම් සුරකින්නද?';

  @override
  String get voiceBreakStart => 'විවේක ගන්න වේලාවයි';

  @override
  String get voiceMoodPrompt => 'ඔබේ වර්තමාන භාවනාව කුමක්ද?';

  @override
  String get voiceMoodSaved => 'භාවනාව සුරකින ලදී. ඉදිරියට යමු.';

  @override
  String voiceMoodSelected(String mood) {
    return '$mood ලෙස භාවනාව තෝරාගෙන ඇත. ඉදිරියට යමු.';
  }

  @override
  String get voiceWelcomeBack => 'ආයුබෝවන්! නැවත ආරම්භ කරන්නද?';

  @override
  String get voiceLeavingSession => 'ඔබ පිටවීමට සූදානම්ද? මෙම සැසිය සුරකින්නද?';

  @override
  String get voiceGenericFallback => 'ඉදිරියට යමු.';

  @override
  String get mood => 'භාවනාව';

  @override
  String get moodHappy => 'සතුටු';

  @override
  String get moodNeutral => 'සාමාන්‍ය';

  @override
  String get moodSad => 'දුකින්';

  @override
  String get moodCrying => 'අඬනවා';

  @override
  String get moodJoyful => 'සතුටු';

  @override
  String get moodAngry => 'කෝපයෙන්';

  @override
  String get moodSurprised => 'පුදුමයෙන්';

  @override
  String get moodConfused => 'අවුල්වීම';

  @override
  String get moodSleepy => 'නිදාගන්නටයි';
}
