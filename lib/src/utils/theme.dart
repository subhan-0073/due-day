import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),

  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF1A1A1A),
    foregroundColor: Colors.tealAccent.shade200,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.tealAccent.shade200,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),

    iconTheme: IconThemeData(color: Colors.tealAccent.shade200),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  textTheme: TextTheme(
    bodyLarge: const TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: const TextStyle(fontSize: 14, color: Colors.white60),
    bodySmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.tealAccent.shade100,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,

    fillColor: const Color(0xFF2A2A2A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.tealAccent.shade200, width: 2),
    ),
    hintStyle: const TextStyle(color: Colors.white54),
  ),
);
