import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0A2342),   // sehr dunkles Blau
    secondary: Color(0xFF1E3A5F), // kühles Mittelblau
    surface: Color(0xFF121E2B),   // fast schwarzer Blauton
    onPrimary: Color(0xFF0C3B73),
    onSecondary: Colors.white,
    onSurface: Color(0xFFD0E1F9), // helles bläuliches Grau für Text
  ),
  scaffoldBackgroundColor: Color(0xFF0A192F), // Hintergrund: tiefdunkles Blau
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0A2342),
    foregroundColor: Color(0xFFD0E1F9),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFFD0E1F9),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFD0E1F9)),
    bodyLarge: TextStyle(color: Color(0xFFD0E1F9)),
    titleLarge: TextStyle(
      color: Color(0xFFD0E1F9),
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1E3A5F),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);
