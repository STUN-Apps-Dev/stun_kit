import 'package:stun_kit/extensions/list_extensions.dart';
import 'package:stun_kit/library/paginator/src/paginator.dart';
import 'package:stun_kit/library/paginator/src/paginator_response.dart';

const kInfinitePageSize = 1000000000;

class ListPaginator<T> implements Paginator<T> {
  final int pageSize;
  final List<T> _data = [];
  PaginatorResponse<T>? _lastResponse;
  List<T> _initialData = [];
  List<T> _searchResults = [];

  ListPaginator({this.pageSize = kInfinitePageSize});

  void setInitialData(List<T> initialData) {
    reset();
    _initialData = List<T>.from(initialData);
    _searchResults = List<T>.from(initialData);
  }

  @override
  Future<List<T>> loadNextPage([PaginatorCallback<T>? action]) async {
    if (canLoadNextPage) {
      if (action == null) {
        final pages = _searchResults.partion(pageSize);

        if (pages.isEmpty) return [];

        final currentPage = (_lastResponse?.currentPage ?? -1) + 1;
        final lastPage = pages.length - 1;
        final data = pages[currentPage];

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

  Future<void> makeSearch([bool Function(T)? compare]) async {
    final items = _initialData.where(compare ?? (_) => true).toList();
    reset();
    _searchResults = List<T>.from(items);
    loadNextPage();
  }

  @override
  Future<void> reset() async {
    _lastResponse = null;
    _data.clear();
    _searchResults.clear();
  }

  @override
  bool get canLoadNextPage {
    final response = _lastResponse;
    if (response == null) return true;
    return response.currentPage < (response.lastPage - 1);
  }

  @override
  List<T> get data => List<T>.from(_data);

  List<T> get initialData => List<T>.from(_initialData);

  @override
  void dispose() {
    reset();
  }
}
