import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stun_kit/models/exceptions/api_exception.dart';
import 'package:stun_kit/view_model/src/mixin/app_state_manager.dart';
import 'package:stun_kit/view_model/src/models/app_state.dart';

/// Виджет [AppStateBuilder] позволяет строить UI в зависимости от текущего состояния,
/// предоставляемого [AppStateManager]. Для каждого типа состояния можно задать отдельный обработчик.
/// Если для конкретного состояния обработчик не задан, используется базовый [builder].
///
/// Для использования этого виджета наследуйте свою ViewModel от [AppStateManager] и передавайте ее
/// через Provider. Затем используйте [AppStateBuilder] для построения UI, которое будет реагировать
/// на изменения состояния.
class AppStateBuilder<T extends AppStateManager> extends StatelessWidget {
  /// Базовый строитель виджета, используемый по умолчанию,
  /// если не задан специальный обработчик для текущего состояния.
  final Widget Function(T vm) builder;

  /// Обработчик состояния [InitialState].
  final Widget Function(T vm)? initialState;

  /// Обработчик состояния [LoadingState].
  final Widget Function(T vm)? loadingState;

  /// Обработчик состояния [ApiErrorState].
  /// Принимает ViewModel и объект [ApiException] с информацией об ошибке API.
  final Widget Function(T vm, ApiException error)? apiErrorState;

  /// Обработчик состояния [BadRequestState].
  /// Принимает ViewModel и объект [ApiException] с информацией о плохом запросе.
  final Widget Function(T vm, ApiException error)? badRequestState;

  /// Обработчик состояния [NoInternetState].
  /// Принимает ViewModel и объект [ApiException] с информацией об отсутствии интернет-соединения.
  final Widget Function(T vm, ApiException error)? noInternetState;

  /// Обработчик состояния [InternalErrorState].
  /// Принимает ViewModel и объект ошибки для внутренних ошибок приложения.
  final Widget Function(T vm, Object error)? internalState;

  /// Конструктор [AppStateBuilder].
  ///
  /// [builder] является обязательным и используется для построения UI по умолчанию,
  /// если для текущего состояния не задан специальный обработчик.
  const AppStateBuilder({
    super.key,
    required this.builder,
    this.initialState,
    this.loadingState,
    this.apiErrorState,
    this.badRequestState,
    this.noInternetState,
    this.internalState,
  });

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр ViewModel, наследуемой от AppStateManager, из Provider.
    final vm = context.watch<T>();

    // Извлекаем текущее состояние приложения из ViewModel.
    final state = vm.state;

    // Локальные переменные для каждого обработчика состояния для удобства.
    final initialState = this.initialState;
    final loadingState = this.loadingState;
    final apiErrorState = this.apiErrorState;
    final badRequestState = this.badRequestState;
    final noInternetState = this.noInternetState;
    final internalState = this.internalState;

    // В зависимости от текущего состояния приложения возвращаем соответствующий виджет.
    if (state is InitialState) {
      // Если состояние - InitialState, используем обработчик initialState, если он задан.
      // Иначе используем базовый builder.
      if (initialState == null) return builder(vm);
      return initialState(vm);
    } else if (state is LoadingState) {
      // Если состояние - LoadingState, используем обработчик loadingState, если он задан.
      // Иначе используем базовый builder.
      if (loadingState == null) return builder(vm);
      return loadingState(vm);
    } else if (state is ApiErrorState) {
      // Если состояние - ApiErrorState, используем обработчик apiErrorState, если он задан.
      // Иначе используем базовый builder.
      if (apiErrorState == null) return builder(vm);
      return apiErrorState(vm, state.exception);
    } else if (state is BadRequestState) {
      // Если состояние - BadRequestState, используем обработчик badRequestState, если он задан.
      // Иначе используем базовый builder.
      if (badRequestState == null) return builder(vm);
      return badRequestState(vm, state.exception);
    } else if (state is NoInternetState) {
      // Если состояние - NoInternetState, используем обработчик noInternetState, если он задан.
      // Иначе используем базовый builder.
      if (noInternetState == null) return builder(vm);
      return noInternetState(vm, state.exception);
    } else if (state is InternalErrorState) {
      // Если состояние - InternalErrorState, используем обработчик internalState, если он задан.
      // Иначе используем базовый builder.
      if (internalState == null) return builder(vm);
      return internalState(vm, state.exception);
    } else {
      // Если состояние не соответствует ни одному из известных типов, используем базовый builder.
      return builder(vm);
    }
  }
}
