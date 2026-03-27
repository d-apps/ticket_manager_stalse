import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData lightThemeData() => ThemeData(
    popupMenuTheme: PopupMenuThemeData(
      iconColor: Color(0xff005FB8),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xff005FB8),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff005FB8),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Color(0xff005FB8),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      primary: Color(0xff005FB8),
      seedColor: Color(0xff005FB8),
      secondary: Color(0xff536070),
      tertiary: Color(0xffD97706),
    ),

  );

  static ThemeData darkThemeData() => ThemeData(
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff005FB8),
      brightness: Brightness.dark,
      primary: const Color(0xff4DA3FF),
      secondary: const Color(0xff8FAADC),
      tertiary: const Color(0xffFF8A3D),
    ),

    scaffoldBackgroundColor: const Color(0xff121212),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1E1E1E),
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xff1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white54),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff4DA3FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),

    dividerColor: Colors.white12,
  );
}