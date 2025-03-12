import 'package:flutter/material.dart';

class FitsyTheme {
  ThemeData getMaterialTheme(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width * 0.05;
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFB8860B),
        // Button selected text color
        onPrimary: Colors.black,
        secondary: Colors.black,
        onSecondary: Colors.black,
        surface: Color(0xFFA4B494),
        // Background
        onSurface: Colors.black,
        // Text color
        error: Color(0xFFFF5252),
        // Error color
        onError: Colors.white, // Text on error color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: fontSize),
        backgroundColor: Color(0xFF8A9C81), // Button background color
        foregroundColor: Colors.black, // Text color
      )),
      textTheme: TextTheme(bodyMedium: TextStyle(fontSize: fontSize)),
      cardTheme: CardTheme(color: Color(0xFFB8C4A8)),
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Color(0xFFB8C4A8), filled: true),
      useMaterial3: true,
    );
  }
}
