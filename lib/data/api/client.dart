abstract class ApiClient {
  Future<Map<String, dynamic>> get(
    String method, [
    Map<String, dynamic> queryParameters = const {},
  ]);

  Future<Map<String, dynamic>> post(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> data = const {},
  });

  Future<Map<String, dynamic>> put(
    String method, [
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> data = const {},
  ]);

  Future<Map<String, dynamic>> delete(
    String method, [
    Map<String, dynamic> queryParameters = const {},
  ]);

  Map<String, dynamic> formatApiException(Object? data);
}
