import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/design_system.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xlRadius,
          ),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlRadius,
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: AppSpacing.xl,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primary,
      ),
    );
  }

  // To ensure backward compatibility where lightTheme is referenced, map it to darkTheme
  static ThemeData get lightTheme => darkTheme;

  static TextTheme _buildTextTheme() {
    final baseTextTheme = ThemeData.dark().textTheme;
    final textColor = AppColors.textPrimary;

    // Use Inter for body texts
    final inter = GoogleFonts.interTextTheme(baseTextTheme).apply(
      bodyColor: textColor,
      displayColor: textColor,
    );
    
    // Use Poppins for headings
    return inter.copyWith(
      displayLarge: GoogleFonts.poppins(textStyle: inter.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(textStyle: inter.displayMedium, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(textStyle: inter.displaySmall, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(textStyle: inter.headlineLarge, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.poppins(textStyle: inter.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(textStyle: inter.headlineSmall, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(textStyle: inter.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(textStyle: inter.titleMedium, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(textStyle: inter.titleSmall, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.poppins(textStyle: inter.labelLarge, fontWeight: FontWeight.w600), // Used in buttons
    );
  }
}
