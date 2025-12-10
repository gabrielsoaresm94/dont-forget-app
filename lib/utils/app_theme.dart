import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF131313);
  static const Color textColor = Color(0xFFDEDEDE);
  static const Color borderColor = Color(0xFFDEDEDE);

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: background,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: textColor),

    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'OCRAStd',
      bodyColor: textColor,
      displayColor: textColor,
    ),

    colorScheme: const ColorScheme.dark(
      primary: textColor,
      onPrimary: textColor,
      surface: background,
      onSurface: textColor,
    ),

    useMaterial3: true,
  );

  static TextStyle headingLarge = const TextStyle(
    fontFamily: 'OCRAStd',
    color: textColor,
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.5,
  );

  static TextStyle headingMedium = const TextStyle(
    fontFamily: 'OCRAStd',
    color: textColor,
    fontSize: 46,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  static TextStyle bodyText = const TextStyle(
    fontFamily: 'OCRAStd',
    color: textColor,
    fontSize: 18,
    letterSpacing: 0.8,
  );
}
