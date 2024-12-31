import 'package:stun_kit/models/exceptions/api_exception.dart';

abstract interface class AppState {}

class InitialState extends AppState {}

class LoadingState extends AppState {}

class ApiErrorState extends AppState {
  final ApiException exception;

  ApiErrorState(this.exception);
}

class BadRequestState extends AppState {
  final ApiException exception;

  BadRequestState(this.exception);
}

class NoInternetState extends AppState {
  final ApiException exception;

  NoInternetState(this.exception);
}

class InternalErrorState extends AppState {
  final Object exception;

  InternalErrorState(this.exception);
}
