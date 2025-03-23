import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:stun_kit/config/config.dart';
import 'package:stun_kit/data/services/analytic_service.dart';

/// Сервис для интеграции с AppMetrica.
///
/// Класс [AppMetricaService] реализует [AnalyticService] и предоставляет метод для инициализации
/// аналитической системы AppMetrica. Если приложение запущено в режиме отладки (debug mode),
/// инициализация не выполняется.
class AppMetricaService implements AnalyticService {
  /// Инициализирует сервис аналитики AppMetrica.
  ///
  /// Если приложение запущено в режиме отладки ([kDebugMode]), метод завершает выполнение без инициализации.
  /// В противном случае, извлекается ключ AppMetrica из переменных окружения и производится активация AppMetrica
  /// с использованием [AppMetricaConfig].
  @override
  Future<void> init() async {
    final key = EnvConfig.getEnv(EnvConstants.appMetricaKey, '');
    if (kDebugMode || key.isEmpty) return;

    await AppMetrica.activate(AppMetricaConfig(key));
  }
}
