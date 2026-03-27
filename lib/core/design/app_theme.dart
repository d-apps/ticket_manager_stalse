import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData lightThemeData() => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      primary: Color(0xff005FB8),
      seedColor: Color(0xff005FB8),
      secondary: Color(0xff536070),
      tertiary: Color(0xffD97706),
    ),

  );

  static ThemeData darkThemeData() => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      primary: Color(0xff005FB8),
      seedColor: Color(0xff005FB8),
      secondary: Color(0xff63789D),
      tertiary: Color(0xffA04401),
    ),
  );
}