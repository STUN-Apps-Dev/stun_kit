import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stun_kit/models/exceptions/api_exception.dart';
import 'package:stun_kit/view_model/app_state.dart';
import 'package:stun_kit/view_model/app_state_notifier.dart';

class AppStateBuilder<T extends AppStateNotifier> extends StatelessWidget {
  final Widget Function() builder;
  final Widget Function()? initialState;
  final Widget Function()? loadingState;
  final Widget Function(ApiException exception)? apiErrorState;
  final Widget Function(ApiException exception)? badRequestState;
  final Widget Function(ApiException exception)? noInternetState;
  final Widget Function(Object exception)? internalState;

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
    final state = context.watch<T>().state;
    final initialState = this.initialState;
    final loadingState = this.loadingState;
    final apiErrorState = this.apiErrorState;
    final badRequestState = this.badRequestState;
    final noInternetState = this.noInternetState;
    final internalState = this.internalState;

    if (state is InitialState) {
      if (initialState == null) return builder();
      return initialState();
    } else if (state is LoadingState) {
      if (loadingState == null) return builder();
      return loadingState();
    } else if (state is ApiErrorState) {
      if (apiErrorState == null) return builder();
      return apiErrorState(state.exception);
    } else if (state is BadRequestState) {
      if (badRequestState == null) return builder();
      return badRequestState(state.exception);
    } else if (state is NoInternetState) {
      if (noInternetState == null) return builder();
      return noInternetState(state.exception);
    } else if (state is InternalErrorState) {
      if (internalState == null) return builder();
      return internalState(state.exception);
    } else {
      return builder();
    }
  }
}
