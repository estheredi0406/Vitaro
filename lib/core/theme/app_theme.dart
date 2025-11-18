import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD90000); // Main deep red
  static const Color secondaryRed = Color(0xFFFF7D7D); // Light red bg
  static const Color textDark = Color(0xFF222222);
  static const Color textLight = Color(0xFF757575);
  static const Color background = Color(0xFFFFFFFF);
  static const Color infoBlue = Color(0xFFEBF4FF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryRed,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto', // Choose font here

      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textDark),
        bodyMedium: TextStyle(color: textLight),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textLight),
      ),

      // ... define other theme properties (appBarTheme, etc.)
    );
  }
}
