import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.navy,
      displayColor: AppColors.navy,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        primary: AppColors.blue,
        secondary: AppColors.red,
        surface: AppColors.white,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.navy,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hint,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.blue, width: 1.6),
        errorBorder: _border(AppColors.red),
        focusedErrorBorder: _border(AppColors.red, width: 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
