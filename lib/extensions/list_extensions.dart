extension ListExtensions<T> on List<T> {
  List<List<T>> partion(int size) {
    if (isEmpty || size <= 0) return [];

    final List<List<T>> result = [];
    for (int i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      result.add(sublist(i, end));
    }
    return result;
  }
}