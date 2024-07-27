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
        displayLarge: GoogleFonts.roboto(
          fontSize: 40,
          color: colorScheme.secondary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 30,
          color: colorScheme.secondary,
        ),
        bodyMedium: GoogleFonts.roboto(),
        displaySmall: GoogleFonts.roboto(),
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: const Color.fromARGB(255, 252, 76, 2),
    onPrimary: Colors.black,
    secondary: Colors.white,
    secondaryFixed: const Color.fromARGB(255, 255, 255, 255),
    onSecondary: const Color(0xFF322942),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: const Color(0xFF241E30),
    brightness: Brightness.light,
    onPrimaryFixedVariant: Colors.lightBlue[50],
    onSecondaryFixedVariant: Colors.white,
  );
  static ColorScheme darkColorScheme = const ColorScheme(
    primary: Color.fromARGB(255, 252, 76, 2),
    secondary: Color.fromARGB(255, 255, 255, 255),
    secondaryFixed: Color.fromARGB(255, 22, 22, 22),
    surface: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color.fromARGB(255, 255, 241, 241),
    brightness: Brightness.dark,
    onPrimaryFixedVariant: Color.fromARGB(255, 35, 49, 56),
    onSecondaryFixedVariant: Color.fromARGB(255, 31, 31, 31),
  );
}

// primaryColor: const Color.fromARGB(255, 252, 76, 2),