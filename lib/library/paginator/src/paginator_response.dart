class PaginatorResponse<T> {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final List<T> data;

  PaginatorResponse({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    required this.data,
  });

  PaginatorResponse.unfiled({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 0,
    this.total = 0,
    this.from = 0,
    this.to = 0,
    this.data = const [],
  });

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

  @override
  String toString() {
    return 'PaginatorResponse{currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, from: $from, to: $to, data: $data}';
  }
}
