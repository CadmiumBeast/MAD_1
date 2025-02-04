import 'package:flutter/material.dart';

class ThemeModifier with ChangeNotifier{
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(){
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}