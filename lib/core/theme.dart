import 'package:flutter/material.dart';

abstract final class BrightColors {
  static const pink = Color(0xffff3569);
  static const ink = Color(0xff202224);
  static const muted = Color(0xff85868b);
  static const canvas = Color(0xfff0f2f8);
  static const line = Color(0xffececf0);
}

TextStyle heading(double size, {Color? color}) => TextStyle(
  fontFamily: 'Josefin Sans',
  fontSize: size,
  height: 1.15,
  fontWeight: FontWeight.w500,
  color: color ?? BrightColors.ink,
);
ThemeData brightTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: BrightColors.pink,
    primary: BrightColors.pink,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, color: BrightColors.ink, height: 1.5),
  ),
  dividerColor: BrightColors.line,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    foregroundColor: BrightColors.ink,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: BrightColors.muted),
    labelStyle: TextStyle(color: BrightColors.muted, fontSize: 14),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: BrightColors.line),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: BrightColors.pink),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 18),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: BrightColors.pink,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1,
      ),
    ),
  ),
);
