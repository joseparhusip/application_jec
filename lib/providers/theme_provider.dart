// theme_provider.dart (KODE BARU)

import 'package:flutter/material.dart';
import '../themes/app_themes.dart';

class ThemeProvider with ChangeNotifier {
  // Tema default adalah terang (light)
  ThemeData _themeData = lightTheme;
  ThemeData get getTheme => _themeData;

  // Enum untuk membantu mengetahui tema mana yang aktif
  AppTheme _currentThemeEnum = AppTheme.light;
  AppTheme get getCurrentThemeEnum => _currentThemeEnum;

  // Fungsi ini tetap ada jika Anda butuh mengatur tema secara eksplisit
  void setTheme(AppTheme theme) {
    if (theme == AppTheme.light) {
      _themeData = lightTheme;
      _currentThemeEnum = AppTheme.light;
    } else {
      _themeData = darkTheme;
      _currentThemeEnum = AppTheme.dark;
    }
    notifyListeners();
  }

  // Fungsi BARU untuk dihubungkan ke Switch
  void toggleTheme() {
    if (_currentThemeEnum == AppTheme.light) {
      setTheme(AppTheme.dark);
    } else {
      setTheme(AppTheme.light);
    }
  }
}