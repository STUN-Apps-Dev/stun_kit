import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Printer {
  static void log(dynamic message) {
    if (!kDebugMode) return;
    developer.log('$message');
  }

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
