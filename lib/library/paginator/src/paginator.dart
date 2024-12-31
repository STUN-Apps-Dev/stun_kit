import 'package:stun_kit/library/paginator/src/paginator_response.dart';

abstract interface class Paginator<T> {
  Future<List<T>> loadNextPage(PaginatorCallback<T> action);

  bool get canLoadNextPage;

  List<T> get data;

  Future<void> reset();

  void dispose();
}

typedef PaginatorCallback<T> = Future<PaginatorResponse<T>>? Function();
