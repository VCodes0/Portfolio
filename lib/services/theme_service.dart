import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';

class ThemeService extends ChangeNotifier {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeData get currentTheme =>
      _isDark ? AppTheme.instance.darkTheme : AppTheme.instance.darkTheme;

  AppColors get colors => AppColors.instance;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
