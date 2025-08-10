import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'OpenSans';

  /// Available palettes for user selection
  static const List<String> availablePalettes = [
    'Teal Clarity',
    'Pink Kindness',
    'Indigo Calm',
  ];

  /// Light theme based on selected palette
  static ThemeData themedLight(String palette) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: _colorSchemeForPalette(palette, Brightness.light),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: Colors.grey[50],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: ThemeData.light().textTheme.copyWith(
        headlineSmall: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: fontFamily),
        titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: fontFamily),
        bodyLarge: const TextStyle(fontSize: 16.0, fontFamily: fontFamily),
        bodyMedium: const TextStyle(fontSize: 14.0, fontFamily: fontFamily),
        labelSmall: const TextStyle(fontSize: 12.0, fontFamily: fontFamily),
      ),
    );
  }

  /// Dark theme based on selected palette
  static ThemeData themedDark(String palette) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: _colorSchemeForPalette(palette, Brightness.dark),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: Colors.grey[900],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: ThemeData.dark().textTheme.copyWith(
        headlineSmall: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: fontFamily),
        titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, fontFamily: fontFamily),
        bodyLarge: const TextStyle(fontSize: 16.0, fontFamily: fontFamily),
        bodyMedium: const TextStyle(fontSize: 14.0, fontFamily: fontFamily),
        labelSmall: const TextStyle(fontSize: 12.0, fontFamily: fontFamily),
      ),
    );
  }

  /// Internal method to generate a ColorScheme from palette name
  static ColorScheme _colorSchemeForPalette(String palette, Brightness brightness) {
    final seed = switch (palette) {
      'Teal Clarity' => Colors.teal,
      'Pink Kindness' => Colors.pink,
      'Indigo Calm' => Colors.indigo,
      _ => Colors.indigo,
    };

    return ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  }

  /// Optional widget to preview palette swatch in UI
  static Widget palettePreview(String palette) {
    final scheme = _colorSchemeForPalette(palette, Brightness.light);
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 8),
        Text(palette, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }
}
