import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Класс для логирования в режиме отладки.
///
/// Все методы не работают, если [kDebugMode] == false.
class Printer {
  /// Логирует сообщение с помощью [developer.log].
  ///
  /// Показывает информацию только в debug-режиме.
  static void log(dynamic message) {
    if (!kDebugMode) return;
    developer.log('$message');
  }

  /// Логирует информационное сообщение с помощью [Logger].
  ///
  /// Показывает информацию только в debug-режиме.
  static void i(dynamic message) {
    if (!kDebugMode) return;

    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        noBoxingByDefault: true,
      ),
    );
    logger.i(message);
  }

  /// Логирует ошибку с помощью [Logger].
  ///
  /// Принимает [message], [error] и [stackTrace].
  /// Показывает информацию только в debug-режиме.
  static void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final logger = Logger(
      printer: PrettyPrinter(
        errorMethodCount: 8,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
    logger.e(message, error: error, stackTrace: stackTrace);
  }
}
