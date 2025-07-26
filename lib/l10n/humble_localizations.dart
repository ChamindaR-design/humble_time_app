import 'package:flutter/material.dart';

class HumbleLocalizations {
  final Locale locale;

  HumbleLocalizations(this.locale);

  static HumbleLocalizations of(BuildContext context) {
    return Localizations.of<HumbleLocalizations>(context, HumbleLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'focusBlockTitle': 'Focus Time',
      'breakBlockTitle': 'Break Time',
      'voiceFocusStart': 'Starting focus block.',
      'voiceBreakStart': 'Take a short break.',
      'logHistory': 'Log History',
      'actuals': 'Actuals',
      'pacing': 'Pacing',
      'scheduler': 'Scheduler',
      'settings': 'Settings',
      'appTitle': 'Humble Time Tracker',
      'welcome': 'Welcome to Humble',
    },
    'ja': {
      'focusBlockTitle': '集中時間',
      'breakBlockTitle': '休憩時間',
      'voiceFocusStart': '集中ブロックを開始します。',
      'voiceBreakStart': '少し休憩しましょう。',
      'logHistory': '履歴ログ',
      'actuals': '実績',
      'pacing': 'ペーシング',
      'scheduler': 'スケジューラー',
      'settings': '設定',
      'appTitle': 'ハンブル時間トラッカー',
      'welcome': 'ようこそハンブルへ',
    },
    'si': {
      'focusBlockTitle': 'ඉස්සරහ කාලය',
      'breakBlockTitle': 'විවේක කාලය',
      'voiceFocusStart': 'ඉස්සරහ කාලය ආරම්භ වේ.',
      'voiceBreakStart': 'සුළු විවේකයක් ගන්න.',
      'logHistory': 'ලොග් ඉතිහාසය',
      'actuals': 'සත්‍ය දත්ත',
      'pacing': 'උපායමාර්ගය',
      'scheduler': 'සැලසුම්කරු',
      'settings': 'සැකසුම්',
      'appTitle': 'හම්බල් වේලාව ට්‍රැකර්',
      'welcome': 'හම්බල් වෙත සාදරයෙන් පිළිගනිමු',
    },
  };

  // Fallback for undefined keys or languages
  String _translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ??
        _localizedStrings['en']?[key] ??
        key;
  }

  String get focusBlockTitle => _translate('focusBlockTitle');
  String get breakBlockTitle => _translate('breakBlockTitle');
  String get voiceFocusStart => _translate('voiceFocusStart');
  String get voiceBreakStart => _translate('voiceBreakStart');

  String get logHistory => _translate('logHistory');
  String get actuals => _translate('actuals');
  String get pacing => _translate('pacing');
  String get scheduler => _translate('scheduler');
  String get settings => _translate('settings');

  String get appTitle => _translate('appTitle');
  String get welcome => _translate('welcome');

  static const LocalizationsDelegate<HumbleLocalizations> delegate = _HumbleLocalizationsDelegate();
}

class _HumbleLocalizationsDelegate extends LocalizationsDelegate<HumbleLocalizations> {
  const _HumbleLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ja', 'si'].contains(locale.languageCode);
  }

  @override
  Future<HumbleLocalizations> load(Locale locale) async {
    return HumbleLocalizations(locale);
  }

  @override
  bool shouldReload(_HumbleLocalizationsDelegate old) => false;
}

