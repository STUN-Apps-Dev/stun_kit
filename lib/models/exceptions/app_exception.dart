abstract class AppException implements Exception {
  final dynamic error;
  late final StackTrace stackTrace;

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
