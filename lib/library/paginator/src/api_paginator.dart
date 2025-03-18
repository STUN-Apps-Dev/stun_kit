import 'dart:async';

import 'package:stun_kit/library/paginator/src/paginator.dart';
import 'package:stun_kit/library/paginator/src/paginator_response.dart';

/// Реализует пагинацию данных, загружаемых через API.
/// Предоставляет механизм задержки запроса для предотвращения частых вызовов.
class ApiPaginator<T> implements Paginator<T> {
  /// Задержка между вызовами загрузки следующей страницы.
  static const _kDebounce = Duration(milliseconds: 1000);

  /// Список накопленных данных.
  final List<T> _data = [];

  /// Последний полученный ответ пагинации.
  PaginatorResponse<T>? _lastResponse;

  /// Таймер, управляющий задержкой перед выполнением запроса.
  Timer? _delayTimer;

  /// Загружает следующую страницу с задержкой.
  ///
  /// [action] — функция обратного вызова, выполняющая загрузку данных.
  /// Возвращает Future, который завершается списком новых элементов.
  Future<List<T>> loadNextPageWithDelay(PaginatorCallback<T> action) async {
    final completer = Completer<List<T>>();

    // Отменяем предыдущий таймер, если он еще активен.
    _delayTimer?.cancel();

    // Устанавливаем новый таймер для задержки вызова.
    _delayTimer = Timer(_kDebounce, () {
      _delayTimer = null;
      completer.complete(loadNextPage(action));
    });

    return completer.future;
  }

  /// Загружает следующую страницу данных.
  ///
  /// Если загрузка возможна (см. [canLoadNextPage]), вызывается функция [action].
  /// Результат сохраняется в [_lastResponse] и добавляется в [_data].
  @override
  Future<List<T>> loadNextPage(PaginatorCallback<T> action) async {
    if (canLoadNextPage) {
      final response = await action();
      if (response == null) return [];

      _lastResponse = response;
      _data.addAll(response.data);

      // Возвращаем копию списка новых данных.
      return List<T>.from(response.data);
    }

    return [];
  }

  /// Сбрасывает текущее состояние пагинации.
  ///
  /// Очищает накопленные данные и сбрасывает последний полученный ответ.
  @override
  Future<void> reset() async {
    _lastResponse = null;
    _data.clear();
  }

  /// Проверяет, можно ли загрузить следующую страницу.
  ///
  /// Если данных еще не было или текущая страница меньше последней – возвращает true.
  @override
  bool get canLoadNextPage {
    final response = _lastResponse;
    if (response == null) return true;
    return response.currentPage < response.lastPage;
  }

  /// Возвращает копию всех накопленных данных.
  @override
  List<T> get data => List<T>.from(_data);

  /// Возвращает номер текущей страницы, или 0, если данных нет.
  int get currentPage => _lastResponse?.currentPage ?? 0;

  /// Освобождает ресурсы, связанные с таймером задержки.
  @override
  void dispose() {
    _delayTimer?.cancel();
  }
}
