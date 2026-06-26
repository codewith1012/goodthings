import 'package:flutter/material.dart';

class AppTheme {
  // Define your exact hex color constants
  static const Color primaryColor = Color(0xFFF4A7B9);
  static const Color secondaryColor = Color(0xFFFF6C8E);
  static const Color tertiaryColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(
    0xFFFFF8F7,
  ); // High-chroma warm white
  static const Color textCharcoal = Color(0xFF4B4445);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,

      // Injecting your palette into Material 3's ColorScheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color.fromARGB(255, 246, 145, 169),
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.black,
        onSurface: textCharcoal,
        tertiaryContainer: Color.fromARGB(255, 251, 177, 67),
      ),

      // Configuring global text theme to use your warm charcoal color
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: "Junge",
          fontSize: 60,
          color: textCharcoal,
        ),
        displayMedium: TextStyle(
          fontFamily: "Junge",
          fontSize: 33,
          color: textCharcoal,
        ),
        titleMedium: TextStyle(
          fontFamily: "Judson",
          fontSize: 20,
          color: textCharcoal,
        ),
        bodySmall: TextStyle(
          fontFamily: "Judson",
          fontSize: 16,
          color: textCharcoal,
        ),
        titleLarge: TextStyle(
          fontFamily: "Judson",
          fontSize: 25,
          color: textCharcoal,
        ),
        titleSmall: TextStyle(
          fontFamily: "Judson",
          fontSize: 18,
          color: textCharcoal,
        ),
      ),

      // Modifications needed
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(splashFactory: InkRipple.splashFactory)
            .copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color(0xFFDAD4DE);
                }
                return null;
              }),
            ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFC9C3CD),
        selectionHandleColor: Color(0xFFC9C3CD),
        selectionColor: Color(0xFFC9C3CD),
      ),
    );
  }
}
