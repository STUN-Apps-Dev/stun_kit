import 'dart:async';

import 'package:stun_kit/library/paginator/src/paginator.dart';
import 'package:stun_kit/library/paginator/src/paginator_response.dart';

class ApiPaginator<T> implements Paginator<T> {
  static const _kDebounce = Duration(milliseconds: 1000);

  final List<T> _data = [];
  PaginatorResponse<T>? _lastResponse;

  Timer? _debounceTimer;

  Future<List<T>> loadNextPageDebounce(PaginatorCallback<T> action) async {
    final completer = Completer<List<T>>();

    _debounceTimer?.cancel();

    _debounceTimer = Timer(_kDebounce, () {
      _debounceTimer = null;
      completer.complete(loadNextPage(action));
    });

    return completer.future;
  }

  @override
  Future<List<T>> loadNextPage(PaginatorCallback<T> action) async {
    if (canLoadNextPage) {
      final response = await action();
      if (response == null) return [];

      _lastResponse = response;
      _data.addAll(response.data);

      return List<T>.from(response.data);
    }

    return [];
  }

  @override
  Future<void> reset() async {
    _lastResponse = null;
    _data.clear();
  }

  @override
  bool get canLoadNextPage {
    final response = _lastResponse;
    if (response == null) return true;
    return response.currentPage < response.lastPage;
  }

  @override
  List<T> get data => List<T>.from(_data);

  int get currentPage => _lastResponse?.currentPage ?? 0;

  @override
  void dispose() {
    _debounceTimer?.cancel();
  }
}
