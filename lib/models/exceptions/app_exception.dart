/// Базовый класс для исключений в приложении.
///
/// Реализует интерфейс [Exception] и хранит описание ошибки вместе со стеком вызова.
/// Этот класс служит основой для создания более специализированных исключений,
/// таких как [ApiException].
class AppException implements Exception {
  /// Описание ошибки. Может представлять строку или любой другой объект,
  /// описывающий суть проблемы.
  final dynamic error;

  /// Стек вызова, связанный с возникновением ошибки.
  /// Если не передан, инициализируется текущим стеком вызова.
  late final StackTrace stackTrace;

  /// Конструктор [AppException].
  ///
  /// [error] — описание ошибки (обязательный параметр).
  /// [stackTrace] — стек вызова (опционально, если не указан, используется [StackTrace.current]).
  AppException({
    required this.error,
    StackTrace? stackTrace,
  }) {
    this.stackTrace = stackTrace ?? StackTrace.current;
  }

  @override
  String toString() {
    return 'AppException{error: $error, stackTrace: $stackTrace}';
  }
}
