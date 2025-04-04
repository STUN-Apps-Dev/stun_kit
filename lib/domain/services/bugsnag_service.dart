import 'dart:async';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:stun_kit/config/src/config.dart';
import 'package:stun_kit/config/src/constants.dart';
import 'package:stun_kit/data/services/exception_service.dart';
import 'package:stun_kit/library/printer/printer.dart';

/// Сервис для интеграции с Bugsnag для отслеживания и обработки исключений.
///
/// Класс [BugsnagService] реализует интерфейс [ExceptionService] и обеспечивает:
/// - Инициализацию Bugsnag с использованием API ключа из переменных окружения.
/// - Перехват глобальных ошибок Flutter и их отправку в Bugsnag.
/// - Логирование ошибок с помощью [Printer.e].
class BugsnagService implements ExceptionService {
  /// Инициализирует сервис Bugsnag.
  ///
  /// Если приложение не запущено в режиме отладки ([kDebugMode]),
  /// извлекается API ключ из переменных окружения и происходит запуск Bugsnag.
  /// Также устанавливается глобальный обработчик ошибок Flutter,
  /// который вызывает метод [capture] для отправки ошибок в Bugsnag.
  @override
  Future<void> init() async {
    final key = EnvConfig.getEnv(EnvConstants.bugsnagKey, '');
    if (!kDebugMode && !kIsWeb && key.isNotEmpty) {
      Printer.i('[BugsnagService] activated ($key)');
      await bugsnag.start(apiKey: key);
    } else {
      Printer.i('[BugsnagService] activate skipped');
    }

    // Устанавливаем глобальный обработчик ошибок Flutter
    FlutterError.onError = (details) {
      capture(details.exception, details.stack);
    };
  }

  /// Перехватывает и обрабатывает исключения.
  ///
  /// Сначала ошибка выводится в лог с помощью [Printer.e].
  /// Если приложение не работает в веб-режиме ([kIsWeb]) и не находится в режиме отладки ([kDebugMode]),
  /// отправляет уведомление об ошибке в Bugsnag.
  ///
  /// [exception] — объект ошибки.
  /// [stackTrace] — опциональная трассировка стека, связанная с ошибкой.
  @override
  Future<void> capture(Object exception, StackTrace? stackTrace) async {
    final key = EnvConfig.getEnv(EnvConstants.bugsnagKey, '');

    Printer.e('', error: exception, stackTrace: stackTrace);

    if (!kDebugMode && !kIsWeb && key.isNotEmpty) {
      return bugsnag.notify(exception, stackTrace);
    }
  }

  /// Отмечает завершение процесса запуска приложения.
  ///
  /// Если приложение не находится в режиме отладки ([kDebugMode]),
  /// вызывает [bugsnag.markLaunchCompleted] для фиксации завершения запуска.
  /// В режиме отладки метод не выполняет никаких действий.
  @override
  FutureOr<void> markLaunchCompleted() {
    final key = EnvConfig.getEnv(EnvConstants.bugsnagKey, '');

    if (!kDebugMode && !kIsWeb && key.isNotEmpty) {
      return bugsnag.markLaunchCompleted();
    }

    return null;
  }
}
