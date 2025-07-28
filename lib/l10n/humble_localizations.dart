import 'package:flutter/material.dart';
import 'package:humble_time_app/l10n/app_localizations.dart';

class HumbleLocalizations {
  final AppLocalizations _inner;

  HumbleLocalizations(this._inner);

  static HumbleLocalizations of(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    assert(localizations != null, 'AppLocalizations not found in context');
    return HumbleLocalizations(localizations!);
  }

  // ✅ Expose the delegate
  static const LocalizationsDelegate<HumbleLocalizations> delegate = HumbleLocalizationsDelegate();

  // ✅ Forwarding getters for all defined keys
  String get focusBlockTitle => _inner.focusBlockTitle;
  String get breakBlockTitle => _inner.breakBlockTitle;
  String get voiceFocusStart => _inner.voiceFocusStart;
  String get voiceBreakStart => _inner.voiceBreakStart;
  String get mood => _inner.mood;
  String get timeMosaicPlanner => _inner.timeMosaicPlanner;

  String get logHistory => _inner.logHistory;
  String get actuals => _inner.actuals;
  String get pacing => _inner.pacing;
  String get scheduler => _inner.scheduler;
  String get settings => _inner.settings;
  String get appTitle => _inner.appTitle;
}

class HumbleLocalizationsDelegate extends LocalizationsDelegate<HumbleLocalizations> {
  const HumbleLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<HumbleLocalizations> load(Locale locale) async {
    final inner = await AppLocalizations.delegate.load(locale);
    return HumbleLocalizations(inner);
  }

  @override
  bool shouldReload(HumbleLocalizationsDelegate old) => false;
}
