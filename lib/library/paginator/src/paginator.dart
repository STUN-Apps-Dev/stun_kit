import 'package:stun_kit/library/paginator/src/paginator_response.dart';

/// Определяет интерфейс для реализации пагинации.
/// Задаёт методы для загрузки следующей страницы, сброса состояния и освобождения ресурсов.
abstract interface class Paginator<T> {
  /// Загружает следующую страницу данных.
  ///
  /// [action] — функция обратного вызова, которая возвращает объект [PaginatorResponse].
  Future<List<T>> loadNextPage(PaginatorCallback<T> action);

  /// Проверяет, возможно ли загрузить следующую страницу.
  bool get canLoadNextPage;

  /// Возвращает все накопленные данные.
  List<T> get data;

  /// Сбрасывает текущее состояние пагинации.
  Future<void> reset();

  /// Освобождает ресурсы, используемые пагинатором.
  void dispose();
}

/// Функция обратного вызова для загрузки данных.
/// Должна возвращать [Future] с объектом [PaginatorResponse].
typedef PaginatorCallback<T> = Future<PaginatorResponse<T>>? Function();
