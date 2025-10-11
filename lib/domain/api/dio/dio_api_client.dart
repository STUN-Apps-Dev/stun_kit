import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:stun_kit/config/src/config.dart';
import 'package:stun_kit/data/api/client.dart';
import 'package:stun_kit/domain/api/dio/interceptors/log_interceptor.dart';
import 'package:stun_kit/models/exceptions/exceptions.dart';

abstract class DioApiClient implements ApiClient {
  late final Dio _client;
  Dio get client => _client;

  void configure();

  void setClient(Dio client) {
    if (EnvConfig.isApiDebug) {
      client.interceptors.add(CustomLogInterceptor());
    }
    _client = client;
  }

  String get errorKey => 'message';

  @override
  Future<Map<String, dynamic>> get(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: _normalizeHeaderKeys(headers)),
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw await _mapDioToAppException(e);
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
      final hdr = _normalizeHeaderKeys(headers);
      final body = _isMultipart(hdr) ? FormData.fromMap(data) : data;
      final res = await _client.post<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: hdr),
        data: body,
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw await _mapDioToAppException(e);
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
      final hdr = _normalizeHeaderKeys(headers);
      final body = _isMultipart(hdr) ? FormData.fromMap(data) : data;
      final res = await _client.put<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: hdr),
        data: body,
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw await _mapDioToAppException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String method, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      final res = await _client.delete<Map<String, dynamic>>(
        method,
        queryParameters: queryParameters,
        options: Options(headers: _normalizeHeaderKeys(headers)),
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw await _mapDioToAppException(e);
    }
  }

  Future<ServerException> _mapDioToAppException(DioException e) async {
    final status = e.response?.statusCode;
    final payload = _toMap(e.response?.data);
    final message = _pickMessage(e, payload, errorKey);

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return ConnectException(
          error: message.isEmpty ? 'Network timeout' : message,
          statusCode: status,
          stackTrace: e.stackTrace,
          response: payload,
        );
      case DioExceptionType.cancel:
        return ServerException(
          error: message.isEmpty ? 'Request cancelled' : message,
          statusCode: status,
          stackTrace: e.stackTrace,
          response: payload,
        );
      case DioExceptionType.badResponse:
        if (status == 401 || status == 403) {
          return AuthException(
            error: _authMessage(message, status),
            statusCode: status,
            stackTrace: e.stackTrace,
            response: payload,
          );
        }
        if (status == 400 ||
            status == 404 ||
            status == 405 ||
            status == 409 ||
            status == 413 ||
            status == 415 ||
            status == 422) {
          return BadRequestException(
            error: message.isEmpty ? 'Bad request' : message,
            statusCode: status,
            stackTrace: e.stackTrace,
            response: payload,
          );
        }
        if (status != null && status >= 500) {
          return ServerException(
            error: message.isEmpty ? 'Server error' : message,
            statusCode: status,
            stackTrace: e.stackTrace,
            response: payload,
          );
        }
        return ServerException(
          error: message.isEmpty ? 'Unexpected response' : message,
          statusCode: status,
          stackTrace: e.stackTrace,
          response: payload,
        );
      case DioExceptionType.unknown:
        final raw = '${e.message ?? ''} ${e.error ?? ''}';
        final looksLikeXhr = raw.contains('XMLHttpRequest error');
        final isSocket = e.error is SocketException;
        if (looksLikeXhr || isSocket) {
          final online = await _isOnlineSafe();
          if (!online) {
            return ConnectException(
              error: 'No internet connection',
              statusCode: status,
              stackTrace: e.stackTrace,
              response: payload,
            );
          }
          return ServerException(
            error: message.isEmpty ? 'Network error' : message,
            statusCode: status,
            stackTrace: e.stackTrace,
            response: payload,
          );
        }
        final online = await _isOnlineSafe();
        if (!online) {
          return ConnectException(
            error: 'No internet connection',
            statusCode: status,
            stackTrace: e.stackTrace,
            response: payload,
          );
        }
        return ServerException(
          error: message.isEmpty ? 'Unknown error' : message,
          statusCode: status,
          stackTrace: e.stackTrace,
          response: payload,
        );
    }
  }

  @override
  Map<String, dynamic> formatApiException(Object? data) => _toMap(data);

  Map<String, dynamic> _normalizeHeaderKeys(Map<String, dynamic> headers) {
    final out = <String, dynamic>{};
    headers.forEach((k, v) => out[k.toLowerCase()] = v);
    return out;
  }

  bool _isMultipart(Map<String, dynamic> headers) {
    final v = headers[Headers.contentTypeHeader] ??
        headers[Headers.contentTypeHeader.toLowerCase()];
    if (v == null) return false;
    return v.toString().toLowerCase().contains('multipart/form-data');
  }

  Map<String, dynamic> _toMap(Object? data) {
    if (data == null) return const {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {}
      return {'data': data};
    }
    return {'data': data.toString()};
  }

  String _pickMessage(DioException e, Map<String, dynamic> body, String key) {
    String? take(dynamic v) => _stringOrFirst(v);
    final candidates = <String?>[
      take(body[key]),
      take(body['message']),
      take(body['error']),
      take(body['detail']),
      take(body['errors']),
      take(body['messages']),
      e.response?.statusMessage,
      e.message,
      e.error?.toString(),
    ];
    return candidates.firstWhere((s) => s != null && s.trim().isNotEmpty,
        orElse: () => '')!;
  }

  String? _stringOrFirst(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is List && v.isNotEmpty) {
      return v.first is String ? v.first : v.first?.toString();
    }
    if (v is Map && v.isNotEmpty) {
      final first = v.values.first;
      if (first is String) return first;
      if (first is List && first.isNotEmpty) {
        final f = first.first;
        return f is String ? f : f?.toString();
      }
      return first?.toString();
    }
    return v.toString();
  }

  String _authMessage(String message, int? status) {
    if (message.trim().isEmpty) {
      if (status == 401) return 'Unauthorized';
      if (status == 403) return 'Forbidden';
    }
    return message;
  }

  Future<bool> _isOnlineSafe() async {
    try {
      return await checkConnection();
    } catch (_) {
      return true;
    }
  }

  Future<bool> checkConnection() async {
    final res = await Connectivity().checkConnectivity();
    return !res.contains(ConnectivityResult.none);
  }

  String getPathParameters(int? value) => value == null ? '' : '/$value';
}
