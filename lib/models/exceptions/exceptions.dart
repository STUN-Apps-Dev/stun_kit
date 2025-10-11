import 'dart:convert';

class AppException implements Exception {
  final Object error;
  final StackTrace stackTrace;

  AppException({
    required this.error,
    StackTrace? stackTrace,
  }) : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return jsonEncode({
      'type': runtimeType.toString(),
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
    });
  }
}

class UnexpectedException extends AppException {
  UnexpectedException({
    required super.error,
    super.stackTrace,
  });
}

class ServerException extends AppException {
  final int? statusCode;
  final Map<String, dynamic> response;

  ServerException({
    required super.error,
    required this.statusCode,
    super.stackTrace,
    this.response = const {},
  });

  @override
  String toString() {
    return jsonEncode({
      'exception': runtimeType.toString(),
      'error': error.toString(),
      'statusCode': statusCode?.toString(),
      'response': response.toString(),
      'stackTrace': stackTrace.toString(),
    });
  }
}

class ConnectException extends ServerException {
  ConnectException({
    required super.error,
    required super.statusCode,
    super.stackTrace,
    super.response = const {},
  });
}

class AuthException extends ServerException {
  AuthException({
    required super.error,
    required super.statusCode,
    super.stackTrace,
    super.response = const {},
  });
}

class BadRequestException extends ServerException {
  BadRequestException({
    required super.error,
    required super.statusCode,
    super.stackTrace,
    super.response = const {},
  });
}
