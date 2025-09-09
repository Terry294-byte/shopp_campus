// File: lib/constants/theme_data.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return ThemeData(
      // Scaffold background
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,

      // Primary colors
      primaryColor: isDarkTheme ? AppColors.darkPrimary : AppColors.lightPrimary,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.red,
        accentColor: isDarkTheme ? AppColors.darkSecondary : AppColors.lightSecondary,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),

      // Card colors
      cardColor: isDarkTheme
          ? AppColors.darkGrey.withOpacity(0.8)
          : AppColors.white,

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
        ),
      ),

      // Text themes
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
        titleLarge: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
        bodyLarge: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
        bodyMedium: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
        labelLarge: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkTheme ? AppColors.darkGrey.withOpacity(0.3) : AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkTheme ? AppColors.lightGrey : AppColors.lightGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkTheme ? AppColors.lightGrey : AppColors.lightGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryRed,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: isDarkTheme ? AppColors.white : AppColors.black,
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? AppColors.darkGrey : AppColors.primaryRed,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
