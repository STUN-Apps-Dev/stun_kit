import 'package:flutter/cupertino.dart';
import 'package:stun_kit/models/exceptions/exceptions.dart';
import 'package:stun_kit/view_model/src/models/app_state.dart';

/// Менеджер состояния приложения, реализующий ChangeNotifier.
///
/// Отвечает за хранение и обновление текущего состояния приложения, а также
/// за обработку исключений и изменение состояния на основе возникших ошибок.
/// Уведомляет слушателей об изменениях состояния.
mixin AppStateManager on ChangeNotifier {
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
    if (_state == state) return;
    _state = state;
    notifyListeners();
  }

  /// Устанавливает новое состояние без уведомления слушателей.
  ///
  /// Используется, когда обновление состояния не требует мгновенного обновления UI.
  void setStateSilent(AppState state) {
    if (_state == state) return;
    _state = state;
  }

  /// Обновляет состояние приложения на основе возникшего исключения.
  ///
  /// Для остальных исключений устанавливается [InternalErrorState].
  void setStateByException(Object error, StackTrace stackTrace) {
    final err = formatException(error, stackTrace);

    handleException(
      error: err,
      stackTrace: err.stackTrace,
      onConnectException: (error) => setState(ConnectExceptionState(error)),
      onBadRequestException: (error) =>
          setState(BadRequestExceptionState(error)),
      onServerException: (error) => setState(ServerExceptionState(error)),
      onUnexpectedException: (error) =>
          setState(UnexpectedExceptionState(error)),
    );
  }

  /// Логирует исключение и вызывает соответствующий callback в зависимости от его типа.
  ///
  /// [error] – возникшее исключение.
  /// [stackTrace] – стек вызовов, сопровождающий исключение (опционально).
  /// Callback-функции:
  /// - [onAuthException] – вызывается при ошибке авторизации.
  /// - [onBadRequestException] – вызывается при ошибке плохого запроса.
  /// - [onConnectException] – вызывается при таймауте запроса.
  /// - [onUnexpectedException] – вызывается для других типов ошибок.
  ///
  /// Перед выполнением callback-функций исключение передаётся в [_exceptionService] для логирования.
  T? handleException<T>({
    required Object error,
    StackTrace? stackTrace,
    T Function(AuthException)? onAuthException,
    T Function(BadRequestException)? onBadRequestException,
    T Function(ConnectException)? onConnectException,
    T Function(ServerException)? onServerException,
    T Function(UnexpectedException)? onUnexpectedException,
  }) {
    if (error is AuthException) {
      return onAuthException?.call(error);
    } else if (error is BadRequestException) {
      return onBadRequestException?.call(error);
    } else if (error is ConnectException) {
      return onConnectException?.call(error);
    } else if (error is ServerException) {
      return onServerException?.call(error);
    } else if (error is UnexpectedException) {
      onUnexpectedException?.call(error);
    }

    final err = UnexpectedException(error: error, stackTrace: stackTrace);
    return onUnexpectedException?.call(err);
  }

  AppException formatException(Object error, StackTrace? stackTrace) {
    if (error is AppException) return error;
    return UnexpectedException(error: error, stackTrace: stackTrace);
  }

  @override
  void notifyListeners() {
    if (!_mounted) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
