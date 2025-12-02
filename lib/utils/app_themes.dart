import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppThemes {
  // ---------------- LIGHT THEME ----------------
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // main background for screens
    scaffoldBackgroundColor: AppColors.lightBackground,

    // global text styling using Manrope
    textTheme: GoogleFonts.manropeTextTheme(),

    // transparent app bar with centered title
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),

    // card style for light mode
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // default input style for textfields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5D9F9)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5D9F9)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    ),
  );

  // ---------------- DARK THEME ----------------
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // main background for dark mode
    scaffoldBackgroundColor: AppColors.darkBackground,

    // text theme adapted to dark visuals
    textTheme: GoogleFonts.manropeTextTheme(
      ThemeData.dark().textTheme,
    ),

    // consistent transparent app bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
    ),

    // card styling for dark mode
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // input field styling for dark mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3B3050),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6A5A85)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6A5A85)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.gradientDarkTop,
          width: 1.4,
        ),
      ),
    ),
  );

  // ---------------- LOGIN GRADIENTS ----------------
  // gradient background for login screen (light mode)
  static const loginLightGradient = LinearGradient(
    colors: [
      AppColors.gradientLightTop,
      AppColors.gradientLightBottom,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // gradient background for login screen (dark mode)
  static const loginDarkGradient = LinearGradient(
    colors: [
      AppColors.gradientDarkTop,
      AppColors.gradientDarkBottom,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ---------------- BUTTON GRADIENT ----------------
  // gradient used for primary buttons
  static const buttonGradient = LinearGradient(
    colors: [
      AppColors.buttonGradientStart,
      AppColors.buttonGradientEnd,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
