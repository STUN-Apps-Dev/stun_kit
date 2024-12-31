import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stun_kit/library/printer/printer.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Printer.i('');
    Printer.i('*** Request Log Start ***');
    _printKV('uri', [options.uri.origin, options.uri.path].join(''));
    _printKV('queryParameters', jsonEncode(options.uri.queryParameters));
    _printKV('responseType', options.responseType.toString());
    _printKV('connectTimeout', options.connectTimeout);
    _printKV('sendTimeout', options.sendTimeout);
    _printKV('receiveTimeout', options.receiveTimeout);
    _printKV('headers', options.headers);
    final data = options.data;
    if (data is FormData) {
      _printKV('data', jsonEncode(_formDataToMap(data)));
      _printKV('files', data.files);
    } else {
      _printKV('data', jsonEncode(data));
    }
    Printer.i('*** Request Log End ***');
    Printer.i('');

    handler.next(options);
  }

  Map<String, dynamic> _formDataToMap(FormData data) {
    final map = <String, dynamic>{};
    map.addEntries(data.fields);
    return map;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri;
    Printer.i('');
    Printer.i('*** Response Log Start ***');
    _printKV('uri', [uri.origin, uri.path].join(''));
    _printKV('queryParameters', uri.queryParameters);
    _printKV('statusCode', response.statusCode);
    _printKV('response', response);
    Printer.i('*** Response Log End ***');
    Printer.i('');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Printer.i('');
    Printer.i('*** DioException Log Start ***:');
    _printKV('uri', err.requestOptions.uri);
    _printKV('error', err);
    _printKV('response', err.response);
    Printer.i('*** DioException Log End ***');
    Printer.i('');

    handler.next(err);
  }

  void _printKV(String key, Object? v) {
    Printer.i('$key: $v');
  }
}
