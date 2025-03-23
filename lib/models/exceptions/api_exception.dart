import 'dart:convert';
import 'package:stun_kit/models/exceptions/app_exception.dart';

/// Исключение для ошибок, возникающих при выполнении API-запросов.
///
/// Расширяет [AppException] и добавляет дополнительные данные, специфичные для API-ошибок,
/// такие как тип ошибки, HTTP-статус код и дополнительные сведения об ошибке.
class ApiException extends AppException {
  /// Тип ошибки API.
  final ApiExceptionType type;

  /// HTTP-статус код, полученный в результате запроса.
  /// Значение по умолчанию: -1, если код не определён.
  final int statusCode;

  /// Дополнительные данные об ошибке, возвращённые API.
  /// Обычно содержит подробную информацию о проблеме.
  final Map<String, dynamic> errors;

  /// Конструктор [ApiException].
  ///
  /// [error] — описание ошибки.
  /// [stackTrace] — стек вызова (опционально, если не указан, используется текущий стек вызова).
  /// [type] — тип ошибки API (обязательный параметр).
  /// [statusCode] — HTTP-статус код, полученный от API (по умолчанию -1).
  /// [errors] — дополнительные данные об ошибке (по умолчанию пустая карта).
  ApiException({
    super.error,
    super.stackTrace,
    required this.type,
    this.statusCode = -1,
    this.errors = const {},
  });

  @override
  String toString() {
    final errorsAsString = errors.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return jsonEncode({
      'exception': runtimeType.toString(),
      'apiExceptionType': type.toString(),
      'error': error.toString(),
      'statusCode': statusCode,
      'errors': errorsAsString,
      'stackTrace': stackTrace.toString(),
    });
  }
}

/// Перечисление типов ошибок API.
enum ApiExceptionType { timeout, auth, badRequest, other }
