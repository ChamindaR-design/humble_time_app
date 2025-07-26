import 'package:flutter/material.dart';

/*class HumbleTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }
}*/

class HumbleTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }
}

