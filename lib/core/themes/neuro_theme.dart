import 'package:flutter/material.dart';

class NeuroTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      surface: Color(0xFFF5F5F5),
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      surface: Color(0xFF1A1A1A),
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  );
}
