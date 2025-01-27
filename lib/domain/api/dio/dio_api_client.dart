import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:stun_kit/app_config/app_config.dart';
import 'package:stun_kit/data/api/client.dart';
import 'package:stun_kit/domain/api/dio/interceptors/log_interceptor.dart';
import 'package:stun_kit/models/exceptions/exceptions.dart';

abstract class DioApiClient implements ApiClient {
  late final Dio _client;

  Dio get client => _client;

  void configure();

  void setClient(Dio client) {
    if (AppConfig.apiLogs) {
      final logInterceptor = CustomLogInterceptor();
      client.interceptors.add(logInterceptor);
    }

    _client = client;
  }

  String get errorKey => 'message';

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

  @override
  Future<Map<String, dynamic>> post(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final isFormDataContentType = headers[Headers.contentTypeHeader] ==
          Headers.multipartFormDataContentType;

      final response = await _client.post<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: isFormDataContentType ? FormData.fromMap(data) : data,
      );

      return response.data ?? {};
    } on DioException catch (e) {
      throw await captureException(e);
    }
  }

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

    return ApiException(
      type: ApiExceptionType.other,
      statusCode: error.response?.statusCode ?? -1,
      error: error.anyMessage(errorKey),
      stackTrace: error.stackTrace,
      errors: errors,
    );
  }
}

extension DioApiClientExt on DioApiClient {
  String getPathParameters(int? value) {
    if (value == null) return '';
    return '/$value';
  }

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

extension DioExceptionExt on DioException {
  String anyMessage(String key) {
    final data = response?.data ?? {};
    var title = response?.statusMessage ?? message ?? error ?? '$this';

    if (data[key] is String) {
      title = data[key] ?? title;
    }

    return '$title';
  }
}
