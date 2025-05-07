import 'package:flutter/cupertino.dart';
import 'package:stun_kit/data/services/exception_service.dart';
import 'package:stun_kit/models/exceptions/api_exception.dart';
import 'package:stun_kit/view_model/src/models/app_state.dart';

/// Менеджер состояния приложения, реализующий ChangeNotifier.
///
/// Отвечает за хранение и обновление текущего состояния приложения, а также
/// за обработку исключений и изменение состояния на основе возникших ошибок.
/// Уведомляет слушателей об изменениях состояния.
mixin AppStateManager on ChangeNotifier {
  /// Сервис для логирования и обработки исключений.
  ExceptionService get exceptionService;

  /// Текущее состояние приложения.
  AppState _state = const InitialState();

  /// Геттер для получения текущего состояния.
  AppState get state => _state;

  /// Флаг, указывающий, что менеджер всё ещё активен (не уничтожен).
  bool _mounted = true;

  /// Устанавливает новое состояние приложения и уведомляет слушателей об изменении.
  ///
  /// Если новое состояние совпадает с текущим или менеджер уже уничтожен (_mounted == false),
  /// обновление не производится.
  void setState(AppState state) {
    if (_state == state || !_mounted) return;
    _state = state;
    notifyListeners();
  }

  /// Устанавливает новое состояние без уведомления слушателей.
  ///
  /// Используется, когда обновление состояния не требует мгновенного обновления UI.
  void setStateSilent(AppState state) {
    if (_state == state || !_mounted) return;
    _state = state;
  }

  /// Обновляет состояние приложения на основе возникшего исключения.
  ///
  /// Если [error] является [ApiException], состояние устанавливается в зависимости
  /// от типа исключения:
  /// - [ApiExceptionType.auth] и [ApiExceptionType.other] – состояние ошибки API.
  /// - [ApiExceptionType.badRequest] – состояние ошибки плохого запроса.
  /// - [ApiExceptionType.timeout] – состояние отсутствия интернет-соединения.
  ///
  /// Для остальных исключений устанавливается [InternalErrorState].
  void setStateByException(Object error) {
    if (error is ApiException) {
      switch (error.type) {
        case ApiExceptionType.auth:
        case ApiExceptionType.other:
          setState(ApiErrorState(error));
          break;
        case ApiExceptionType.badRequest:
          setState(BadRequestState(error));
          break;
        case ApiExceptionType.timeout:
          setState(NoInternetState(error));
          break;
      }
    } else {
      setState(InternalErrorState(error));
    }
  }

  /// Логирует исключение и вызывает соответствующий callback в зависимости от его типа.
  ///
  /// [error] – возникшее исключение.
  /// [stackTrace] – стек вызовов, сопровождающий исключение (опционально).
  /// Callback-функции:
  /// - [onAuthError] – вызывается при ошибке авторизации.
  /// - [onBadRequestError] – вызывается при ошибке плохого запроса.
  /// - [onTimeoutError] – вызывается при таймауте запроса.
  /// - [onOtherError] – вызывается для других типов ошибок.
  ///
  /// Перед выполнением callback-функций исключение передаётся в [_exceptionService] для логирования.
  void handleException<T>({
    required Object error,
    StackTrace? stackTrace,
    T Function(ApiException)? onAuthError,
    T Function(ApiException)? onBadRequestError,
    T Function(ApiException)? onTimeoutError,
    T Function(ApiException)? onOtherError,
  }) {
    exceptionService.capture(error, stackTrace);

    if (error is ApiException) {
      switch (error.type) {
        case ApiExceptionType.auth:
          onAuthError?.call(error);
          break;
        case ApiExceptionType.badRequest:
          onBadRequestError?.call(error);
          break;
        case ApiExceptionType.timeout:
          onTimeoutError?.call(error);
          break;
        case ApiExceptionType.other:
          onOtherError?.call(error);
          break;
      }
    }
  }

  /// Освобождает ресурсы и устанавливает флаг _mounted в false, чтобы предотвратить дальнейшие обновления.
  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}
