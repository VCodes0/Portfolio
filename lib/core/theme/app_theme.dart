import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  AppTheme._();
  static final AppTheme instance = AppTheme._();

  ThemeData get darkTheme {
    final colors = AppColors.instance;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.accent,
        surface: colors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colors.textPrimary,
        error: colors.error,
      ),
      textTheme: _buildTextTheme(colors),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: BorderSide(color: colors.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      iconTheme: IconThemeData(color: colors.textSecondary, size: 24),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        hintStyle: TextStyle(color: colors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.xl,
            vertical: AppDimensions.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.xl,
            vertical: AppDimensions.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(AppColors colors) {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.poppins(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -2,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -1.5,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -1,
        height: 1.2,
      ),
      // Headline
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      // Title
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.textPrimary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
      ),
      // Body
      bodyLarge: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        height: 1.7,
      ),
      bodyMedium: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textMuted,
        height: 1.5,
      ),
      // Label
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colors.textMuted,
        letterSpacing: 1,
      ),
    );
  }
}
