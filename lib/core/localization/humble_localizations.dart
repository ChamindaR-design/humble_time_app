import 'package:flutter/material.dart';

class HumbleLocalizations {
  final Locale locale;

  HumbleLocalizations(this.locale);

  String get focusBlockTitle => 'Focus Time';
  String get breakBlockTitle => 'Break Time';

  String get voiceFocusStart => 'Starting focus block.';
  String get voiceBreakStart => 'Take a short break.';

  static HumbleLocalizations of(BuildContext context) {
    return Localizations.of<HumbleLocalizations>(context, HumbleLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Humble Time Tracker',
      'welcome': 'Welcome to Humble',
    },
    'ja': {
      'appTitle': 'ハンブル時間トラッカー',
      'welcome': 'ようこそハンブルへ',
    },
    'si': {
      'appTitle': 'හම්බල් වේලාව ට්‍රැකර්',
      'welcome': 'හම්බල් වෙත සාදරයෙන් පිළිගනිමු',
    },
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]!['appTitle']!;
  }

  String get welcome {
    return _localizedValues[locale.languageCode]!['welcome']!;
  }

  static const LocalizationsDelegate<HumbleLocalizations> delegate = _HumbleLocalizationsDelegate();
}

class _HumbleLocalizationsDelegate extends LocalizationsDelegate<HumbleLocalizations> {
  const _HumbleLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ja', 'si'].contains(locale.languageCode);
  }

  @override
  Future<HumbleLocalizations> load(Locale locale) {
    return Future.value(HumbleLocalizations(locale));
  }

  @override
  bool shouldReload(_HumbleLocalizationsDelegate old) => false;
}

