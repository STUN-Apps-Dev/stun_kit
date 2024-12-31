import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDark {
    return _brightness == Brightness.dark;
  }

  bool get isLight {
    return _brightness == Brightness.light;
  }

  Brightness get _brightness {
    final themeMode = AdaptiveTheme.of(this).mode;

    if (themeMode.isDark) {
      return Brightness.light;
    } else if (themeMode.isLight) {
      return Brightness.dark;
    } else {
      return MediaQuery.of(this).platformBrightness;
    }
  }
}

extension ThemeDataExt on ThemeData {
  TextStyle? get h1 => textTheme.displayLarge;

  TextStyle? get h2 => textTheme.displayMedium;

  TextStyle? get h3 => textTheme.displaySmall;

  TextStyle? get h4 => textTheme.headlineMedium;

  TextStyle? get button => textTheme.labelLarge;

  TextStyle? get buttonLink => textTheme.labelLarge;

  TextStyle? get text => textTheme.bodyMedium;

  TextStyle? get greyText => textTheme.titleLarge;

  TextStyle? get description => textTheme.titleSmall;

  TextStyle? get smallText => textTheme.labelSmall;
}
