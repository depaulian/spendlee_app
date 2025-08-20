import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const themeKey = 'selectedTheme';

  var themeMode = ThemeMode.system.obs; // Default theme is system

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs();
  }

  // Load the selected theme from SharedPreferences
  void loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTheme = prefs.getString(themeKey);
    if (storedTheme != null) {
      themeMode.value = themeModeFromString(storedTheme);
    }
  }

  // Save the selected theme to SharedPreferences
  void saveThemeToPrefs(ThemeMode theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(themeKey, theme.toString().split('.').last);
  }

  // Set the theme and save it
  void setTheme(ThemeMode theme) {
    themeMode.value = theme;
    saveThemeToPrefs(theme);
  }

  // Convert string to ThemeMode
  ThemeMode themeModeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // Check if the current theme is dark
  bool isDarkMode(BuildContext context) {
    return themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }
}