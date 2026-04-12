import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFF2A900);
  static const Color primaryDark = Color(0xFFD18C00);
  static const Color backgroundColor = Color(0xFFF5F0E6);
  static const Color cardColor = Color(0xFFEFE6D8);
  static const Color textPrimary = Color(0xFF5A3E1B);
  static const Color accentColor = Color(0xFFFFD54F);
  static const Color white = Colors.white;
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: white,
      secondary: accentColor,
      onSecondary: textPrimary,
      error: Colors.red,
      onError: white,
      surface: cardColor,
      onSurface: textPrimary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    cardTheme: CardThemeData(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
    ),
    dividerColor: primaryDark.withOpacity(0.3),
  );
}
