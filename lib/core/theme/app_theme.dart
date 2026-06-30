import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the global [ThemeData] for the app.
class AppTheme {
  AppTheme._();

  static const double radiusSm = 10;
  static const double radiusMd = 12;
  static const double radiusCard = 14;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy900,
      primary: AppColors.navy900,
      secondary: AppColors.gold500,
      surface: AppColors.surface,
      error: AppColors.danger,
      brightness: Brightness.light,
    );

    final TextTheme textTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      headlineMedium: AppTextStyles.headingLarge,
      titleLarge: AppTextStyles.headingMedium,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navy900,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x140F2744),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy900,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy900,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.navy900, width: 1.4),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy800,
          textStyle: AppTextStyles.button,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold500,
        foregroundColor: AppColors.navy900,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        labelStyle: AppTextStyles.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.gold500, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMuted,
        selectedColor: AppColors.navy900,
        labelStyle: AppTextStyles.bodySmall,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.navy900,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy900,
        contentTextStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    );
  }
}

/// Reusable soft shadow for surfaces.
const List<BoxShadow> kSoftShadow = [
  BoxShadow(
    color: Color(0x0F0F2744),
    blurRadius: 16,
    offset: Offset(0, 6),
  ),
];

const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Color(0x0A0F2744),
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
];
