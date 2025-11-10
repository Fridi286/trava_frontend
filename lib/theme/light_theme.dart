import 'package:flutter/material.dart';
import '../utils/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFD9B48F),   // warmes Beige
    secondary: Color(0xFFB58B68), // helles Braun
    surface: Color(0xFFFFF8F0),   // sehr helles Creme
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF5B4636), // dunklerer Text
  ),
  scaffoldBackgroundColor: Color(0xFFFFF8F0), // cremefarbener Hintergrund
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFD9B48F),
    foregroundColor: Color(0xFF5B4636),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFF5B4636),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF5B4636)),
    bodyLarge: TextStyle(color: Color(0xFF5B4636)),
    titleLarge: TextStyle(
      color: Color(0xFF5B4636),
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFB58B68),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);
