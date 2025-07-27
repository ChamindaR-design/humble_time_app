import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'OpenSans';

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
  );
}
