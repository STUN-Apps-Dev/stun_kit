import 'package:stun_kit/models/exceptions/app_exception.dart';

class ApiException extends AppException {
  final ApiExceptionType type;
  final int statusCode;
  final Map<String, dynamic> errors;

  ApiException({
    super.error,
    super.stackTrace,
    required this.type,
    this.statusCode = -1,
    this.errors = const {},
  });

  @override
  String toString() {
    return 'ApiException{type: $type, statusCode: $statusCode, errors: $errors}';
  }
}

enum ApiExceptionType { timeout, auth, badRequest, other }
