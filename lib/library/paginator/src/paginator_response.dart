/// Класс, описывающий ответ пагинации.
///
/// Содержит информацию о текущей странице, размере страницы,
/// общем количестве элементов и диапазоне элементов на странице.
class PaginatorResponse<T> {
  /// Номер текущей страницы.
  final int currentPage;

  /// Номер последней страницы.
  final int lastPage;

  /// Количество элементов на странице.
  final int perPage;

  /// Общее количество элементов.
  final int total;

  /// Индекс первого элемента на странице.
  final int from;

  /// Индекс последнего элемента на странице.
  final int to;

  /// Список элементов текущей страницы.
  final List<T> data;

  /// Основной конструктор.
  PaginatorResponse({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    required this.data,
  });

  /// Конструктор для случая, когда данные отсутствуют или не заданы.
  PaginatorResponse.unfiled({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 0,
    this.total = 0,
    this.from = 0,
    this.to = 0,
    this.data = const [],
  });

  /// Создает объект [PaginatorResponse] из [Map].
  factory PaginatorResponse.fromMap(Map<String, dynamic> json) {
    return PaginatorResponse(
      currentPage: json['current_pages'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      from: json['from'] as int,
      to: json['to'] as int,
      data: json['data'] as List<T>,
    );
  }

  /// Возвращает строковое представление объекта.
  @override
  String toString() {
    return 'PaginatorResponse{currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, from: $from, to: $to, data: $data}';
  }
}
