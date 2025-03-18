import 'package:stun_kit/extensions/list_extensions.dart';
import 'package:stun_kit/library/paginator/src/paginator.dart';
import 'package:stun_kit/library/paginator/src/paginator_response.dart';

/// Константа, задающая практически бесконечный размер страницы.
const kInfinitePageSize = 1000000000;

/// Реализует пагинацию для работы со списками данных.
///
/// Позволяет задавать исходные данные, выполнять поиск и разбивать данные на страницы.
class ListPaginator<T> implements Paginator<T> {
  /// Размер страницы.
  final int pageSize;

  /// Список накопленных данных.
  final List<T> _data = [];

  /// Последний полученный ответ пагинации.
  PaginatorResponse<T>? _lastResponse;

  /// Исходный набор данных, задаваемый пользователем.
  List<T> _initialData = [];

  /// Результаты поиска (отфильтрованные [_initialData]).
  List<T> _searchResults = [];

  /// Конструктор с опциональным указанием размера страницы.
  ListPaginator({this.pageSize = kInfinitePageSize});

  /// Устанавливает исходные данные и сбрасывает текущее состояние пагинации.
  ///
  /// [initialData] — список начальных данных.
  void setInitialData(List<T> initialData) {
    reset();
    _initialData = List<T>.from(initialData);
    _searchResults = List<T>.from(initialData);
  }

  /// Загружает следующую страницу данных.
  ///
  /// Если [action] не передана, используется внутренняя логика разделения [_searchResults]
  /// на страницы. В противном случае вызывается функция [action].
  @override
  Future<List<T>> loadNextPage([PaginatorCallback<T>? action]) async {
    if (canLoadNextPage) {
      if (action == null) {
        // Разбиваем результаты поиска на страницы.
        final pages = _searchResults.partion(pageSize);

        if (pages.isEmpty) return [];

        final currentPage = (_lastResponse?.currentPage ?? -1) + 1;
        final lastPage = pages.length - 1;
        final data = pages[currentPage];

        // Формируем объект ответа пагинации.
        final response = PaginatorResponse<T>(
          currentPage: currentPage,
          lastPage: lastPage,
          perPage: pageSize,
          total: _searchResults.length,
          from: pageSize * currentPage,
          to: (pageSize * currentPage) + data.length,
          data: data,
        );

        _lastResponse = response;
        _data.addAll(response.data);

        return List<T>.from(response.data);
      } else {
        final response = await action();
        if (response == null) return [];

        _lastResponse = response;
        _data.addAll(response.data);

        return List<T>.from(response.data);
      }
    }

    return [];
  }

  /// Выполняет поиск в исходных данных с использованием фильтра.
  ///
  /// [compare] — функция сравнения, которая определяет, какие элементы оставить.
  /// После фильтрации происходит сброс текущего состояния и загрузка первой страницы.
  Future<void> makeSearch([bool Function(T)? compare]) async {
    final items = _initialData.where(compare ?? (_) => true).toList();
    reset();
    _searchResults = List<T>.from(items);
    loadNextPage();
  }

  /// Сбрасывает состояние пагинации, очищая накопленные данные и результаты поиска.
  @override
  Future<void> reset() async {
    _lastResponse = null;
    _data.clear();
    _searchResults.clear();
  }

  /// Проверяет, можно ли загрузить следующую страницу.
  ///
  /// Если данных еще не было или текущая страница меньше (lastPage - 1) – возвращает true.
  @override
  bool get canLoadNextPage {
    final response = _lastResponse;
    if (response == null) return true;
    return response.currentPage < (response.lastPage - 1);
  }

  /// Возвращает копию всех накопленных данных.
  @override
  List<T> get data => List<T>.from(_data);

  /// Возвращает копию исходных данных.
  List<T> get initialData => List<T>.from(_initialData);

  /// Освобождает ресурсы, сбрасывая состояние пагинации.
  @override
  void dispose() {
    reset();
  }
}
