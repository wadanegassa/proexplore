import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.system;

  AppProvider(this._storageService) {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadSettings() {
    final isDark = _storageService.get(StorageService.settingsBox, 'isDark');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _storageService.put(StorageService.settingsBox, 'isDark', isDark);
    notifyListeners();
  }
}
