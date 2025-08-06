import 'package:flutter/material.dart';

class AppColors {
  static const Color light = Color(0xFF000000);
  static const Color lightMuted = Color(0xFFe3dfca);
  static const Color base = Color(0xFFB6A39E);
  static const Color dark = Color(0xFF948B89);
  static const Color olive = Color(0xFFBBBA95);
  static const Color golden = Color(0xFFc2b88f);
  static const Color lightYellow = Color(0xFFC4C9A6);
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme darkColorScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,

      // Primary color for buttons, highlights
      primary: Color(0xFFCE8537),
      // active button
      onPrimary: AppColors.dark,
      // text on primary (base)

      // Used for primary color containers (like ElevatedButton) //
      primaryContainer: AppColors.golden,
      onPrimaryContainer: AppColors.light,

      // Secondary - accents or less prominent components

      secondary: AppColors.dark,
      onSecondary: AppColors.dark,

      secondaryContainer: AppColors.dark,
      onSecondaryContainer: AppColors.dark,

      // Error colors (keeping defaults)
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFB00020),
      onErrorContainer: Color(0xFFFFFFFF),

      // Surface colors for cards, sheets, etc.
      surface: AppColors.lightMuted,
      // main background
      onSurface: AppColors.light,

      // Variants
      surfaceTint: AppColors.dark,
      onSurfaceVariant: AppColors.dark,
      // inactive button color //
      outline: AppColors.base,
      outlineVariant: AppColors.dark,

      // Inverse colors for dark/light contrast (e.g. snackbars)
      inverseSurface: AppColors.light,
      onInverseSurface: AppColors.dark,
      inversePrimary: AppColors.dark,

      // Misc
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      // Material 3 surfaces
      surfaceDim: AppColors.dark,
      surfaceBright: AppColors.dark,
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: 4,
        minimumSize: Size(60, 50),
        backgroundColor: colorScheme.primaryContainer,
        // force button bg color
        foregroundColor: colorScheme.onPrimaryContainer,
      )),
      cardTheme: CardTheme(
        color: AppColors.lightYellow,
        // card background
        surfaceTintColor: colorScheme.primaryContainer,
        // for Material 3 elevation tint
        shadowColor: Colors.black,
        // optional
        elevation: 3,
        // optional
        margin: EdgeInsets.all(8), // optional
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        // background
        hintStyle: TextStyle(color: Colors.black54),
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ));
}
