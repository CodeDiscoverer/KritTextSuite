import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.white;
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFB3B3B3);
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.primary, fontSize: 16),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: AppColors.lightBackground,
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
