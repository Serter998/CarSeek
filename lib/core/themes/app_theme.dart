import 'package:car_seek/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(
  selectedColor >= 0 &&
      selectedColor <= AppColors.themeColors.length - 1,
  'El índice de colores debe estar entre 0 y ${AppColors.themeColors.length - 1}',
  );

  ThemeData theme() {
    final Color primaryColor = AppColors.themeColors[selectedColor];

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xFF121212),
      ),
    );
  }
}
