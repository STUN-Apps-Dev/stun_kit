import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:stun_kit/data/services/theme_service.dart';

class AdaptiveThemeService implements ThemeService {
  @override
  Future<ThemeMode> fetchRecentTheme() async {
    final theme = await AdaptiveTheme.getThemeMode();
    return (theme ?? AdaptiveThemeMode.system).toThemMode();
  }

  @override
  void setThemeMode(BuildContext context, ThemeMode themeMode) {
    AdaptiveTheme.of(context).setThemeMode(themeMode.toThemMode());
  }
}

extension AdaptiveThemeModeExt on AdaptiveThemeMode {
  ThemeMode toThemMode() {
    switch (this) {
      case AdaptiveThemeMode.dark:
        return ThemeMode.dark;
      case AdaptiveThemeMode.light:
        return ThemeMode.light;
      case AdaptiveThemeMode.system:
        return ThemeMode.system;
    }
  }
}

extension ThemeModeExt on ThemeMode {
  AdaptiveThemeMode toThemMode() {
    switch (this) {
      case ThemeMode.dark:
        return AdaptiveThemeMode.dark;
      case ThemeMode.light:
        return AdaptiveThemeMode.light;
      case ThemeMode.system:
        return AdaptiveThemeMode.system;
    }
  }
}
