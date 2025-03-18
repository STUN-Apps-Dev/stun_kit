import 'package:stun_kit/models/exceptions/api_exception.dart';

/// Базовый класс для представления состояния приложения.
///
/// Все конкретные состояния приложения должны наследоваться от этого класса.
abstract interface class AppState {
  const AppState();
}

/// Состояние приложения при инициализации.
///
/// Используется, когда приложение только запускается и состояние ещё не определено.
class InitialState extends AppState {
  const InitialState();
}

/// Состояние загрузки.
///
/// Отображается, когда приложение выполняет загрузку данных или какие-либо операции.
class LoadingState extends AppState {
  const LoadingState();
}

/// Состояние ошибки API.
///
/// Хранит экземпляр [ApiException] с информацией об ошибке, возникшей при выполнении API-запроса.
/// Применяется для ошибок авторизации или других API-ошибок, не относящихся к плохому запросу.
class ApiErrorState extends AppState {
  final ApiException exception;

  const ApiErrorState(this.exception);
}

/// Состояние ошибки плохого запроса (Bad Request).
///
/// Хранит экземпляр [ApiException] с информацией об ошибке, связанной с некорректным запросом.
class BadRequestState extends AppState {
  final ApiException exception;

  const BadRequestState(this.exception);
}

/// Состояние отсутствия интернет-соединения или таймаута запроса.
///
/// Хранит экземпляр [ApiException], отражающий проблему с подключением к сети.
class NoInternetState extends AppState {
  final ApiException exception;

  const NoInternetState(this.exception);
}

/// Состояние внутренней ошибки приложения.
///
/// Хранит объект [exception], описывающий ошибку, которая не связана с выполнением API-запроса.
class InternalErrorState extends AppState {
  final Object exception;

  const InternalErrorState(this.exception);
}
