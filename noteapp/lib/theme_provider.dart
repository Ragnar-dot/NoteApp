import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    Hive.box('settings').put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void _loadTheme() async {
    final box = Hive.box('settings');
    _isDarkMode = box.get('isDarkMode', defaultValue: false);
    notifyListeners();
  }
}