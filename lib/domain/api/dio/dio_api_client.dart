import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:stun_kit/config/src/config.dart';
import 'package:stun_kit/data/api/client.dart';
import 'package:stun_kit/domain/api/dio/interceptors/log_interceptor.dart';
import 'package:stun_kit/models/exceptions/exceptions.dart';

/// Абстрактный класс для реализации API клиента с использованием Dio.
///
/// [DioApiClient] реализует [ApiClient] и предоставляет методы для выполнения
/// HTTP запросов (GET, POST, PUT, DELETE) с обработкой исключений.
/// В случае возникновения ошибок запросов происходит их преобразование в [ApiException].
abstract class DioApiClient implements ApiClient {
  /// Экземпляр [Dio] для выполнения HTTP запросов.
  late final Dio _client;

  /// Возвращает текущий экземпляр [Dio] клиента.
  Dio get client => _client;

  /// Метод для дополнительной конфигурации клиента.
  ///
  /// Реализация данного метода должна быть предоставлена в подклассах.
  void configure();

  /// Устанавливает экземпляр [Dio] клиента и настраивает его.
  ///
  /// Если включён режим отладки API (см. [EnvConfig.isApiDebug]),
  /// добавляется [CustomLogInterceptor] для логирования запросов.
  ///
  /// [client] — экземпляр [Dio], который будет использоваться для выполнения запросов.
  void setClient(Dio client) {
    if (EnvConfig.isApiDebug) {
      final logInterceptor = CustomLogInterceptor();
      client.interceptors.add(logInterceptor);
    }

    _client = client;
  }

  /// Ключ, используемый для извлечения сообщения об ошибке из ответа.
  String get errorKey => 'message';

  /// Выполняет HTTP DELETE запрос.
  ///
  /// [method] — URL или путь для запроса.
  /// [queryParameters] — опциональные параметры запроса.
  /// [headers] — опциональные заголовки запроса (не используются в данном методе).
  ///
  /// Возвращает [Future] с данными ответа в виде [Map<String, dynamic>].
  /// В случае ошибки выбрасывает [ApiException] с подробностями ошибки.
  @override
  Future<Map<String, dynamic>> delete(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      final response = await _client.delete<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw await captureException(e);
    }
  }

  /// Выполняет HTTP GET запрос.
  ///
  /// [method] — URL или путь для запроса.
  /// [queryParameters] — опциональные параметры запроса.
  /// [headers] — опциональные заголовки запроса (не используются в данном методе).
  ///
  /// Возвращает [Future] с данными ответа в виде [Map<String, dynamic>].
  /// В случае возникновения ошибки выбрасывает [ApiException] с подробностями ошибки.
  @override
  Future<Map<String, dynamic>> get(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw await captureException(e);
    }
  }

  /// Выполняет HTTP POST запрос.
  ///
  /// [method] — URL или путь для запроса.
  /// [queryParameters] — опциональные параметры запроса.
  /// [headers] — опциональные заголовки запроса.
  /// [data] — данные, передаваемые в теле запроса.
  ///
  /// Если заголовок `Content-Type` соответствует multipart/form-data,
  /// данные преобразуются в [FormData].
  ///
  /// Возвращает [Future] с данными ответа в виде [Map<String, dynamic>].
  /// В случае ошибки выбрасывает [ApiException] с подробностями ошибки.
  @override
  Future<Map<String, dynamic>> post(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final isFormData = _checkIsFormData(headers);

      final response = await _client.post<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: isFormData ? FormData.fromMap(data) : data,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw await captureException(e);
    }
  }

  /// Выполняет HTTP PUT запрос.
  ///
  /// [method] — URL или путь для запроса.
  /// [queryParameters] — опциональные параметры запроса.
  /// [headers] — опциональные заголовки запроса (не используются в данном методе).
  /// [data] — данные, передаваемые в теле запроса.
  ///
  /// Возвращает [Future] с данными ответа в виде [Map<String, dynamic>].
  /// В случае возникновения ошибки выбрасывает [ApiException] с подробностями ошибки.
  @override
  Future<Map<String, dynamic>> put(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final response = await _client.put<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        data: data,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw await captureException(e);
    }
  }

  /// Обрабатывает исключения типа [DioException] и преобразует их в [ApiException].
  ///
  /// [error] — исключение, возникшее при выполнении HTTP запроса.
  ///
  /// Возвращает [Future<ApiException>] с преобразованной ошибкой, учитывая тип ошибки
  /// и статусный код ответа.
  Future<ApiException> captureException(DioException error) async {
    final errors = formatApiException(error.response?.data ?? {});

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(type: ApiExceptionType.timeout);
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        if ([400, 404].contains(error.response?.statusCode)) {
          return ApiException(
            type: ApiExceptionType.badRequest,
            statusCode: error.response?.statusCode ?? -1,
            error: error.anyMessage(errorKey),
            stackTrace: error.stackTrace,
            errors: errors,
          );
        } else if ([401].contains(error.response?.statusCode)) {
          return ApiException(
            type: ApiExceptionType.auth,
            statusCode: error.response?.statusCode ?? -1,
            error: error.anyMessage(errorKey),
            stackTrace: error.stackTrace,
            errors: errors,
          );
        } else if ([403].contains(error.response?.statusCode)) {
          return ApiException(
            type: ApiExceptionType.other,
            statusCode: error.response?.statusCode ?? -1,
            error: error.anyMessage(errorKey),
            stackTrace: error.stackTrace,
            errors: errors,
          );
        } else if (error
            .anyMessage(errorKey)
            .contains('XMLHttpRequest error')) {
          final isConnected = await checkConnection();
          if (!isConnected) {
            return ApiException(
              type: ApiExceptionType.timeout,
              statusCode: error.response?.statusCode ?? -1,
              error: error.anyMessage(errorKey),
              stackTrace: error.stackTrace,
              errors: errors,
            );
          } else {
            return ApiException(
              type: ApiExceptionType.other,
              statusCode: error.response?.statusCode ?? -1,
              error: error.anyMessage(errorKey),
              stackTrace: error.stackTrace,
              errors: errors,
            );
          }
        }
      default:
        return ApiException(
          type: ApiExceptionType.other,
          statusCode: error.response?.statusCode ?? -1,
          error: error.anyMessage(errorKey),
          stackTrace: error.stackTrace,
          errors: errors,
        );
    }

    // Данный код не будет достигнут, но добавлен для полноты.
    return ApiException(
      type: ApiExceptionType.other,
      statusCode: error.response?.statusCode ?? -1,
      error: error.anyMessage(errorKey),
      stackTrace: error.stackTrace,
      errors: errors,
    );
  }

  @override
  Map<String, dynamic> formatApiException(Object? data) {
    if (data == null) {
      return {};
    } else if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map<dynamic, dynamic>) {
      return data.map((key, value) => MapEntry('$key', value));
    }
    return {};
  }

  bool _checkIsFormData(Map<String, dynamic> headers) {
    final header = headers[Headers.contentTypeHeader];
    return header == Headers.multipartFormDataContentType;
  }
}

/// Расширение для [DioApiClient] с дополнительными вспомогательными методами.
extension DioApiClientExt on DioApiClient {
  /// Формирует строку из числового параметра для использования в URL.
  ///
  /// [value] — числовой параметр.
  /// Если [value] равен `null`, возвращается пустая строка,
  /// иначе возвращается строка вида `"/value"`.
  String getPathParameters(int? value) {
    if (value == null) return '';
    return '/$value';
  }

  /// Проверяет наличие интернет-соединения.
  ///
  /// Возвращает [Future<bool>]:
  /// - `true`, если устройство подключено к сети,
  /// - `false`, если отсутствует подключение.
  Future<bool> checkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) return false;
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Расширение для [DioException] с дополнительными методами для обработки ошибок.
///
/// Предоставляет метод для извлечения сообщения об ошибке из ответа.
extension DioExceptionExt on DioException {
  /// Извлекает сообщение об ошибке из данных ответа.
  ///
  /// [key] — ключ, по которому ищется сообщение об ошибке.
  /// Если сообщение найдено в данных ответа, оно возвращается;
  /// иначе используются значения из [statusMessage], [message] или [error].
  /// Если ни одно значение не найдено, возвращается строковое представление исключения.
  String anyMessage(String key) {
    final data = response?.data ?? {};
    var title = response?.statusMessage ?? message ?? error ?? '$this';

    if (data[key] is String) {
      title = data[key] ?? title;
    }

    return '$title';
  }
}
