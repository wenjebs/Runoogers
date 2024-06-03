import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalThemeData {
  static const Color _lightFocusColor = Colors.black;
  static const Color _darkFocusColor = Colors.white;
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      secondaryHeaderColor: Colors.white,
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontStyle: FontStyle.italic,
          color: colorScheme.secondary,
        ),
        bodyMedium: GoogleFonts.merriweather(),
        displaySmall: GoogleFonts.pacifico(),
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 252, 76, 2),
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Color(0xFF322942),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    secondary: Color(0xFF4D1F7C),
    surface: Color(0xFF1F1929),
    error: Colors.redAccent,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );
}

// primaryColor: const Color.fromARGB(255, 252, 76, 2),