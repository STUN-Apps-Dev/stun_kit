import 'dart:async';

import 'package:flutter/material.dart';

class AppRouter {
  AppRouter({
    required this.router,
    required this.rootNavigatorKey,
    required this.scaffoldMessengerKey,
  });

  final RouterConfig<Object> router;

  final GlobalKey<NavigatorState> rootNavigatorKey;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  final ValueNotifier<bool> _isOpen = ValueNotifier<bool>(false);
  bool get isOpen => _isOpen.value;

  final ValueNotifier<bool> _snackOpen = ValueNotifier<bool>(false);
  bool get isSnackOpen => _snackOpen.value;

  bool _attached = false;
  bool _closingByRouteChange = false;

  void attach() {
    if (_attached) return;
    _attached = true;

    router.routerDelegate.addListener(_onRouteChanged);
  }

  void detach() {
    if (!_attached) return;
    _attached = false;
    router.routerDelegate.removeListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    if (isOpen) {
      unawaited(_dismissIfOpen());
    }
    if (isSnackOpen) {
      _hideSnackBarInternal();
    }
  }

  Future<void> _dismissIfOpen() async {
    if (!isOpen) return;
    _closingByRouteChange = true;
    final nav = rootNavigatorKey.currentState;
    if (nav?.canPop() == true) {
      nav?.pop();
    }

    await Future<void>.microtask(() {});
    _closingByRouteChange = false;
    _isOpen.value = false;
  }

  Future<T?> showDialogWidget<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) async {
    await _dismissIfOpen();
    _isOpen.value = true;
    try {
      final ctx = rootNavigatorKey.currentContext!;
      final res = await showDialog<T>(
        context: ctx,
        useRootNavigator: true,
        barrierDismissible: barrierDismissible,
        builder: (_) => dialog,
      );
      return res;
    } finally {
      if (!_closingByRouteChange) _isOpen.value = false;
    }
  }

  Future<T?> showBottomSheetWidget<T>({
    required Widget sheet,
    bool isScrollControlled = true,
  }) async {
    await _dismissIfOpen();
    _isOpen.value = true;
    try {
      final ctx = rootNavigatorKey.currentContext!;
      final res = await showModalBottomSheet<T>(
        context: ctx,
        useRootNavigator: true,
        isScrollControlled: isScrollControlled,
        builder: (_) => sheet,
      );
      return res;
    } finally {
      if (!_closingByRouteChange) _isOpen.value = false;
    }
  }

  Future<void> closeIfOpen() => _dismissIfOpen();

  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool replace = true,
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
  }) {
    final messenger = _messengerOrNull();
    if (replace) {
      messenger?.hideCurrentSnackBar();
    }
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: behavior,
        margin: margin,
      ),
    );
    _snackOpen.value = true;
  }

  void hideSnackBar() {
    _hideSnackBarInternal();
  }

  void clearSnackBars() {
    final messenger = _messengerOrNull();
    messenger?.clearSnackBars();
    _snackOpen.value = false;
  }

  void _hideSnackBarInternal() {
    final messenger = _messengerOrNull();
    messenger?.hideCurrentSnackBar();
    _snackOpen.value = false;
  }

  ScaffoldMessengerState? _messengerOrNull() {
    final byKey = scaffoldMessengerKey.currentState;
    if (byKey != null) return byKey;

    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return null;
    return ScaffoldMessenger.maybeOf(ctx);
  }
}
