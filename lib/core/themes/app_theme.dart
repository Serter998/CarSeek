import 'package:flutter/material.dart';

const Color _customColor = Color.fromARGB(245, 7, 179, 167);
const List<Color> _colorThemes = [
  _customColor,
  Color.fromRGBO(52, 73, 94, 1),
  Color.fromRGBO(231, 76, 60, 1),
  Color.fromRGBO(46, 204, 113, 1),
  Color.fromRGBO(241, 196, 15, 1),
  Color.fromRGBO(155, 89, 182, 1),
  Color.fromRGBO(52, 152, 219, 1),
  Color.fromRGBO(230, 126, 34, 1),
  Color.fromRGBO(39, 174, 96, 1),
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(
  selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
  'El índice de colores debe estar entre 0 y ${_colorThemes.length - 1}',
  );

  ThemeData theme() {
    final Color primaryColor = _colorThemes[selectedColor];

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
