import 'package:example/data/models/todo.dart';
import 'package:example/data/models/todo_filter.dart';
import 'package:example/domain/services/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stun_kit/stun_kit.dart';

class PaginatorExampleVM extends ChangeNotifier with AppStateManager {
  @override
  final ExceptionService exceptionService;

  final _paginator = ApiPaginator<Todo>();

  List<Todo> get todos => _paginator.data;

  final searchController = TextEditingController();

  final _todoService = TodoService();

  PaginatorExampleVM({required this.exceptionService}) {
    _init();
    searchController.addListener(_searchTodos);
  }

  Future<void> _init() async {
    await fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      setState(const LoadingState());
      await _paginator.loadNextPageWithDelay(() async {
        final response = await _todoService.fetchTodos(
          TodoFilter(
            page: _paginator.currentPage + 1,
            q: searchController.text,
          ),
        );
        return PaginatorResponse(
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          data: response.data,
          perPage: response.perPage,
          total: response.to,
          from: response.from,
          to: response.to,
        );
      });
      setState(const InitialState());
    } catch (error, _) {
      setStateByException(error);
    }
  }

  Future<void> _searchTodos() async {
    try {
      setState(const LoadingState());
      _paginator.reset();

      await _paginator.loadNextPageWithDelay(() async {
        final response = await _todoService.fetchTodos(
          TodoFilter(
            page: _paginator.currentPage + 1,
            q: searchController.text,
          ),
        );
        return PaginatorResponse(
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          perPage: response.perPage,
          total: response.to,
          from: response.from,
          to: response.to,
          data: response.data,
        );
      });
      setState(const InitialState());
    } catch (error, _) {
      setStateByException(error);
    }
  }
}
