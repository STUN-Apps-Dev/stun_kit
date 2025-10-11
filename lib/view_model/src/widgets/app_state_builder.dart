import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final Widget Function(T vm) builder;

  final Widget Function(T vm)? onInitialState;

  final Widget Function(T vm)? onLoadingState;

  final Widget Function(T vm, ServerExceptionState state)?
      onServerExceptionState;

  final Widget Function(T vm, BadRequestExceptionState state)?
      onBadRequestExceptionState;

  final Widget Function(T vm, ConnectExceptionState state)?
      onConnectExceptionState;

  final Widget Function(T vm, UnexpectedExceptionState state)?
      onUnexpectedExceptionState;

  /// Конструктор [AppStateBuilder].
  ///
  /// [builder] является обязательным и используется для построения UI по умолчанию,
  /// если для текущего состояния не задан специальный обработчик.
  const AppStateBuilder({
    super.key,
    required this.builder,
    this.onInitialState,
    this.onLoadingState,
    this.onServerExceptionState,
    this.onBadRequestExceptionState,
    this.onConnectExceptionState,
    this.onUnexpectedExceptionState,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<T>();
    final state = vm.state;

    if (state is InitialState) {
      return onInitialState != null ? onInitialState!(vm) : builder(vm);
    }
    if (state is LoadingState) {
      return onLoadingState != null ? onLoadingState!(vm) : builder(vm);
    }
    if (state is ServerExceptionState) {
      return onServerExceptionState != null
          ? onServerExceptionState!(vm, state)
          : builder(vm);
    }
    if (state is BadRequestExceptionState) {
      return onBadRequestExceptionState != null
          ? onBadRequestExceptionState!(vm, state)
          : builder(vm);
    }
    if (state is ConnectExceptionState) {
      return onConnectExceptionState != null
          ? onConnectExceptionState!(vm, state)
          : builder(vm);
    }
    if (state is UnexpectedExceptionState) {
      return onUnexpectedExceptionState != null
          ? onUnexpectedExceptionState!(vm, state)
          : builder(vm);
    }

    return builder(vm);
  }
}
