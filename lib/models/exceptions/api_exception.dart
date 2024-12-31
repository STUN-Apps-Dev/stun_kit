import 'package:stun_kit/models/exceptions/app_exception.dart';

abstract class ApiException extends AppException {
  final ApiExceptionType type;
  final int? statusCode;

  ApiException({
    super.error,
    super.stackTrace,
    required this.type,
    this.statusCode,
  });

  @override
  String toString() {
    return 'ApiException{error: $error, stackTrace: $stackTrace, type: $type, statusCode: $statusCode}';
  }
}

enum ApiExceptionType { timeout, auth, badRequest, other }
