import 'dart:async';

abstract interface class ExceptionService {
  Future<void> init();

  Future<void> capture(Object error, StackTrace? stackTrace);

  FutureOr<void> markLaunchCompleted();
}
