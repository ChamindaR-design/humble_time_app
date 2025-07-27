import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humble_time_app/l10n/humble_localizations.dart';

class AppLocalizations {
  static const delegates = [
    HumbleLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLocales = [
    Locale('en', ''), // English
    Locale('ja', ''), // Japanese
    Locale('si', ''), // Sinhala
  ];
}
