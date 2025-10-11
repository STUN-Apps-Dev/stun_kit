import 'package:stun_kit/models/exceptions/exceptions.dart';

abstract interface class AppState {
  const AppState();
}

class InitialState extends AppState {
  const InitialState();
}

class LoadingState extends AppState {
  const LoadingState();
}

class ServerExceptionState extends AppState {
  final ServerException error;

  const ServerExceptionState(this.error);
}

class BadRequestExceptionState extends AppState {
  final BadRequestException error;

  const BadRequestExceptionState(this.error);
}

class ConnectExceptionState extends AppState {
  final ConnectException error;

  const ConnectExceptionState(this.error);
}

class UnexpectedExceptionState extends AppState {
  final UnexpectedException error;

  const UnexpectedExceptionState(this.error);
}
