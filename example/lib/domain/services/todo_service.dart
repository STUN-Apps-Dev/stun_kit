import 'package:example/data/models/api_response.dart';
import 'package:example/data/models/todo.dart';
import 'package:example/data/models/todo_filter.dart';
import 'package:stun_kit/stun_kit.dart';

class TodoService {
  Future<ApiResponse<Todo>> fetchTodos(final TodoFilter filter) async {
    await Future.delayed(Duration(seconds: 3));

    final currentPage = filter.page - 1;
    final lastPage = filter.page + 3;
    final perPage = 20;

    final result = _generateRandomTodos();
    final searchResult = _searchTodos(result, filter.q);
    final data = searchResult.partion(perPage)[currentPage];

    return ApiResponse(
      currentPage: currentPage + 1,
      lastPage: lastPage,
      perPage: perPage,
      total: lastPage * perPage,
      from: currentPage * perPage,
      to: (lastPage * perPage) - perPage,
      data: data,
    );
  }

  List<Todo> _searchTodos(List<Todo> todos, String query) {
    if (query.isEmpty) return todos;
    return todos.where((el) => el.title.contains(query)).toList();
  }

  List<Todo> _generateRandomTodos() {
    return List.generate(1000, (index) {
      final id = index + 1;
      return Todo(id: id, title: 'Todo #$id');
    });
  }
}
