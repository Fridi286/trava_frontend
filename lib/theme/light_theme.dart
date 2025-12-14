import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF566978),   // Graublau (AppBar / Primary)
    secondary: Color(0xFFE57C9A), // Rosa (Akzente)
    surface: Color(0xFFC7D2FA),   // Helles Lavendel (Cards, Flächen)
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF465664), // Dunkles Blau-Grau für Text
  ),

  scaffoldBackgroundColor: Color(0xFFC7D2FA),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF566978),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF465664)),
    bodyLarge: TextStyle(color: Color(0xFF465664)),
    titleLarge: TextStyle(
      color: Color(0xFF465664),
      fontWeight: FontWeight.bold,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFC80F5A), // Magenta-Pink
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);
