import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    surface: const Color(0xFFF8F9FA),
    primary: Colors.orange.shade700,
    secondary: Colors.white,
    tertiary: Colors.grey.shade200,
    inversePrimary: Colors.grey.shade900,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Color(0xFF212121),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Color(0xFF212121)),
  ),

  // FIX: Use CardTheme (or CardThemeData depending on your specific Flutter version)
  // Most modern versions use CardTheme but ensure it's configured for M3
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0, // M3 looks better with 0 elevation and a subtle border or surface tint
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.shade200, width: 1), // Subtle border for "shiny" look
      borderRadius: BorderRadius.circular(20), // Slightly rounder for premium feel
    ),
  ),
);