import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.blue,
      canvasColor: AppColors.white,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: GoogleFonts.latoTextTheme(),
      appBarTheme: AppBarTheme(
        color: AppColors.blue,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGray, // Background color
          foregroundColor: AppColors.white, // Text color
        ),
      ),
      // buttonTheme: ButtonThemeData(
      //   buttonColor: AppColors.blue,
      //   textTheme: ButtonTextTheme.primary,
      // ),
      // textTheme: TextTheme(
      //   bodyLarge: TextStyle(color: AppColors.darkGray),
      //   bodyMedium: TextStyle(color: AppColors.mediumGray),
      // ),
      colorScheme: ColorScheme.light(
        primary: AppColors.blue,
        primaryContainer: AppColors.lightGray,
        secondary: AppColors.green,
        secondaryContainer: AppColors.mediumGray,
        background: AppColors.white,
        surface: AppColors.lightGray,
        error: AppColors.red,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkGray,
        onBackground: AppColors.darkGray,
        onSurface: AppColors.darkGray,
        onError: AppColors.white,
      ),
    );
  }
}
