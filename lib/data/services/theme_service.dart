import 'package:flutter/material.dart';

abstract class ThemeService {
  Future<ThemeMode> fetchRecentTheme();

  void setThemeMode(BuildContext context, ThemeMode themeMode);
}
