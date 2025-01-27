import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
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
