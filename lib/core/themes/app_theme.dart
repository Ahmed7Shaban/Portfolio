import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFE0E8F6),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: null, // أو حدد لون خاص
  );

  static ThemeData getThemeData(ThemeMode mode) {
    return mode == ThemeMode.dark ? dark : light;
  }
}
