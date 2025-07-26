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
  String get voiceFocusStart => 'Starting Focus Block';

  @override
  String get breakBlockTitle => 'Break Block';

  @override
  String get voiceBreakStart => 'Time for a break';
}
