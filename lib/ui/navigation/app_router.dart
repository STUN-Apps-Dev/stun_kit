import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as oktoast;

abstract class AppRouter {
  static late final RootStackRouter _router;

  static RootStackRouter get instance => _router;

  static bool _isDialogOpened = false;

  static bool get isDialogOpened => _isDialogOpened;

  static registerInstance<T extends RootStackRouter>(T router) {
    _router = router;
  }

  static void unfocus(BuildContext context) {
    return FocusScope.of(context).unfocus();
  }

  static Future<void> closeDialog<T>([T? result]) async {
    if (_isDialogOpened) {
      _isDialogOpened = false;
      await _router.maybePopTop(result);
    }
  }

  static Future<T?> openDialog<T>({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    bool useSafeArea = true,
  }) async {
    await closeDialog();
    _isDialogOpened = true;

    final result = await _router.pushNativeRoute<T>(
      DialogRoute(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        builder: (_) => PopScope(
          onPopInvokedWithResult: (_, __) {
            _isDialogOpened = false;
          },
          child: dialog,
        ),
      ),
    );

    return result;
  }

  static void dismissToast() {
    oktoast.dismissAllToast();
  }

  static oktoast.ToastFuture toast(
    String title, {
    Widget? child,
  }) {
    return oktoast.showToastWidget(
      const SizedBox.shrink(),
      position: oktoast.ToastPosition.bottom,
      handleTouch: true,
      dismissOtherToast: true,
      duration: const Duration(seconds: 3),
    );
  }

  static Future<void> openBottomSheet(
    BuildContext context,
    Widget Function(BuildContext) builder, {
    ShapeBorder? shape,
  }) async {
    await closeDialog();
    _isDialogOpened = true;
    return showModalBottomSheet(
      context: context,
      builder: builder,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: shape,
    ).then((value) {
      _isDialogOpened = false;
      return value;
    });
  }

  static bool canPop() {
    return _router.canPop();
  }

  static Future<bool> pop<T>([T? result]) async {
    if (canPop()) {
      await closeDialog();
      return _router.maybePopTop(result);
    }
    return false;
  }

  static Future<T?> pushNamed<T>(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    await closeDialog();
    return _router.pushNamed(uri.toString());
  }

  static Future<T?> push<T>(PageRouteInfo route) async {
    await closeDialog();
    return _router.push(route);
  }

  static Future<T?> replaceNamed<T>(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    await closeDialog();
    return _router.replaceNamed(uri.toString());
  }

  static Future<T?> replace<T>(PageRouteInfo route) async {
    await closeDialog();
    return _router.replace(route);
  }

  static Future<void> navigateTo(
      BuildContext context, PageRouteInfo route) async {
    await closeDialog();
    return context.navigateTo(route);
  }

  static Future<void> navigateNamedTo(
    BuildContext context,
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    await closeDialog();
    return context.navigateNamedTo(uri.toString());
  }
}

extension StackRouterExt on StackRouter {
  String get activePath {
    final segments = currentPath.split('/');
    return segments.lastOrNull ?? currentPath;
  }

  String get previousPath {
    final path = currentPath;
    final segments = path.split('/');
    if (segments.isEmpty) return currentPath;
    segments.removeLast();
    return segments.join('/');
  }

  String get activeRoot {
    final segments = currentPath.split('/');
    if (segments.isEmpty) return currentPath;

    segments.removeAt(0);

    if (segments.isEmpty) return currentPath;

    final root = segments.firstOrNull;
    if (root == null) return currentPath;
    return '/$root';
  }

  Uri get uri => navigationHistory.urlState.uri;

  Map<String, String> get queryParameters {
    return navigationHistory.urlState.uri.queryParameters;
  }
}
