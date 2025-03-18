import 'dart:async';

/// Интерфейс для аналитических сервисов приложения.
///
/// Определяет контракт для сервисов, которые предоставляют функциональность
/// аналитики, включая активацию процессов сбора и обработки данных.
abstract interface class AnalyticService {
  /// Активирует аналитический сервис.
  ///
  /// Метод должен инициализировать необходимые процессы для начала сбора
  /// и обработки аналитических данных. Возвращает [Future], завершающийся
  /// после успешной активации сервиса.
  Future<void> init();
}
