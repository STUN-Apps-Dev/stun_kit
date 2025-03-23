import 'package:flutter/material.dart';

/// Расширение для BuildContext, предоставляющее удобный доступ к текущей теме приложения.
///
/// Позволяет получить [ThemeData] из контекста с помощью короткого вызова.
extension ThemeExt on BuildContext {
  /// Возвращает текущую тему, используя [Theme.of].
  ThemeData get theme => Theme.of(this);
}

/// Расширение для ThemeData, добавляющее удобные геттеры для различных текстовых стилей.
///
/// Эти геттеры облегчают доступ к часто используемым текстовым стилям, определённым в [textTheme].
extension TypographyExt on ThemeData {
  /// Стиль для заголовка первого уровня.
  TextStyle? get h1 => textTheme.displayLarge;

  /// Стиль для заголовка второго уровня.
  TextStyle? get h2 => textTheme.displayMedium;

  /// Стиль для заголовка третьего уровня.
  TextStyle? get h3 => textTheme.displaySmall;

  /// Стиль для заголовка четвёртого уровня.
  TextStyle? get h4 => textTheme.headlineMedium;

  /// Стиль для кнопок.
  TextStyle? get button => textTheme.labelLarge;

  /// Стиль для ссылок-кнопок (аналогичный стилю кнопок).
  TextStyle? get buttonLink => textTheme.labelLarge;

  /// Основной текстовый стиль для содержимого.
  TextStyle? get text => textTheme.bodyMedium;

  /// Стиль для текста с серым оттенком, часто используемый для заголовков.
  TextStyle? get greyText => textTheme.titleLarge;

  /// Стиль для описательного текста.
  TextStyle? get description => textTheme.titleSmall;

  /// Стиль для мелкого текста.
  TextStyle? get smallText => textTheme.labelSmall;
}
