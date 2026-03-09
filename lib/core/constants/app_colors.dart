import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static final AppColors instance = AppColors._();

  final Color primary = const Color(0xFF6C63FF);
  final Color primaryLight = const Color(0xFF9D97FF);
  final Color primaryDark = const Color(0xFF4A42D6);

  final Color accent = const Color(0xFFFF6584);
  final Color accentLight = const Color(0xFFFF92A8);

  final Color background = const Color(0xFF0D0D1A);
  final Color surface = const Color(0xFF1A1A2E);
  final Color surfaceVariant = const Color(0xFF16213E);
  final Color surfaceHover = const Color(0xFF252540);

  final Color textPrimary = const Color(0xFFE8E8FF);
  final Color textSecondary = const Color(0xFFA0A0C0);
  final Color textMuted = const Color(0xFF6B6B8A);

  final Color border = const Color(0xFF2A2A45);
  final Color divider = const Color(0xFF1E1E35);

  final Color success = const Color(0xFF4CAF50);
  final Color error = const Color(0xFFCF6679);
  final Color warning = const Color(0xFFFFB74D);

  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get heroGradient => LinearGradient(
    colors: [
      const Color(0xFF0D0D1A),
      const Color(0xFF1A1A2E),
      const Color(0xFF0D0D1A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get cardGradient => LinearGradient(
    colors: [surface, surfaceVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
