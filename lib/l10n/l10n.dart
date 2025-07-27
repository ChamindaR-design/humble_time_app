import 'package:flutter/material.dart';

class L10n {
  static const supportedLocales = [
    Locale('en'), // English
    Locale('ja'), // Japanese
    Locale('si'), // Sinhala
  ];

  static Locale fallbackLocale = const Locale('en');

  static bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }
}
