import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as oktoast;

/// Класс для управления навигацией и диалогами в приложении.
///
/// Реализует набор статических методов для работы с роутером и управлением диалоговыми окнами.
abstract class AppRouter {
  /// Хранит единственный экземпляр [RootStackRouter].
  static late final RootStackRouter _router;

  /// Возвращает зарегистрированный экземпляр [RootStackRouter].
  static RootStackRouter get instance => _router;

  /// Флаг, указывающий, открыто ли диалоговое окно.
  static bool _isDialogOpened = false;

  /// Возвращает статус открытия диалогового окна.
  static bool get isDialogOpened => _isDialogOpened;

  /// Регистрирует экземпляр [RootStackRouter] для дальнейшего использования.
  ///
  /// [router] — экземпляр роутера, который будет использоваться в приложении.
  static void registerInstance<T extends RootStackRouter>(T router) {
    _router = router;
  }

  /// Снимает фокус с текущего виджета.
  ///
  /// [context] — контекст, в котором необходимо снять фокус.
  static void unfocus(BuildContext context) {
    return FocusScope.of(context).unfocus();
  }

  /// Открывает диалоговое окно.
  ///
  /// [context] — контекст для отображения диалога.
  /// [dialog] — виджет, представляющий диалог.
  /// [barrierDismissible] — возможность закрытия диалога нажатием вне его области (по умолчанию true).
  /// [barrierColor] — цвет затемнения фона (по умолчанию Colors.black54).
  /// [useSafeArea] — учитывать безопасную зону экрана (по умолчанию true).
  ///
  /// Возвращает результат, полученный после закрытия диалога.
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

  /// Закрывает текущее диалоговое окно, если оно открыто.
  ///
  /// [result] — опциональный результат, который может быть возвращён при закрытии диалога.
  static Future<void> closeDialog<T>([T? result]) async {
    if (_isDialogOpened) {
      _isDialogOpened = false;
      await _router.maybePopTop(result);
    }
  }

  /// Открывает тост-сообщение.
  ///
  /// [child] — опциональный виджет для отображения в тосте.
  ///
  /// Возвращает [ToastFuture] для управления жизненным циклом тоста.
  static oktoast.ToastFuture openToast(Widget child) {
    return oktoast.showToastWidget(
      child,
      position: oktoast.ToastPosition.bottom,
      handleTouch: true,
      dismissOtherToast: true,
      duration: const Duration(seconds: 3),
    );
  }

  /// Закрывает все отображаемые тосты.
  static void closeToast() {
    oktoast.dismissAllToast();
  }

  /// Открывает нижний лист (BottomSheet) в приложении.
  ///
  /// [context] — контекст для отображения нижнего листа.
  /// [builder] — функция для построения содержимого нижнего листа.
  /// [shape] — опциональная форма нижнего листа.
  ///
  /// Возвращает результат закрытия нижнего листа.
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

  /// Проверяет, можно ли выполнить операцию pop (возврат назад) в навигационной истории.
  static bool canPop() {
    return _router.canPop();
  }

  /// Выполняет операцию pop (возврат назад) с возможным результатом.
  ///
  /// [result] — опциональный результат, который может быть возвращён.
  ///
  /// Возвращает [true], если pop выполнен, иначе [false].
  static Future<bool> pop<T>([T? result]) async {
    if (canPop()) {
      await closeDialog();
      return _router.maybePopTop(result);
    }
    return false;
  }

  /// Переходит по заданному имени маршрута.
  ///
  /// [path] — путь маршрута.
  /// [queryParameters] — опциональные параметры запроса.
  ///
  /// Возвращает результат навигации.
  static Future<T?> pushPath<T>(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    await closeDialog();
    return _router.pushPath(uri.toString());
  }

  /// Переходит на указанный маршрут.
  ///
  /// [route] — информация о маршруте в виде [PageRouteInfo].
  ///
  /// Возвращает результат навигации.
  static Future<T?> push<T>(PageRouteInfo route) async {
    await closeDialog();
    return _router.push(route);
  }

  /// Заменяет текущий маршрут на новый по имени.
  ///
  /// [path] — путь нового маршрута.
  /// [queryParameters] — опциональные параметры запроса.
  ///
  /// Возвращает результат замены маршрута.
  static Future<T?> replacePath<T>(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    await closeDialog();
    return _router.replacePath(uri.toString());
  }

  /// Заменяет текущий маршрут на новый.
  ///
  /// [route] — информация о новом маршруте в виде [PageRouteInfo].
  ///
  /// Возвращает результат замены маршрута.
  static Future<T?> replace<T>(PageRouteInfo route) async {
    await closeDialog();
    return _router.replace(route);
  }

  /// Выполняет навигацию к указанному маршруту, используя расширение [BuildContext.navigateTo].
  ///
  /// [context] — контекст для навигации.
  /// [route] — информация о маршруте.
  static Future<void> navigateTo(
      BuildContext context, PageRouteInfo route) async {
    await closeDialog();
    return context.navigateTo(route);
  }

  /// Выполняет навигацию к маршруту по имени, используя расширение [BuildContext.navigateToPath].
  ///
  /// [context] — контекст для навигации.
  /// [path] — путь маршрута.
  /// [queryParameters] — опциональные параметры запроса.
  static Future<void> navigateToPath(
    BuildContext context,
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final uri = Uri(
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    await closeDialog();
    return context.navigateToPath(uri.toString());
  }
}

/// Расширение для [StackRouter] с дополнительными методами для работы с навигационным состоянием.
extension StackRouterExt on StackRouter {
  /// Возвращает последний сегмент текущего пути.
  String get activePath {
    final segments = currentPath.split('/');
    return segments.lastOrNull ?? currentPath;
  }

  /// Возвращает путь предыдущего маршрута.
  String get previousPath {
    final path = currentPath;
    final segments = path.split('/');
    if (segments.isEmpty) return currentPath;
    segments.removeLast();
    return segments.join('/');
  }

  /// Возвращает корневой сегмент активного маршрута.
  String get activeRoot {
    final segments = currentPath.split('/');
    if (segments.isEmpty) return currentPath;

    segments.removeAt(0);

    if (segments.isEmpty) return currentPath;

    final root = segments.firstOrNull;
    if (root == null) return currentPath;
    return '/$root';
  }

  /// Возвращает текущий [Uri] навигационной истории.
  Uri get uri => navigationHistory.urlState.uri;

  /// Возвращает параметры запроса текущего [Uri].
  Map<String, String> get queryParameters {
    return navigationHistory.urlState.uri.queryParameters;
  }
}
