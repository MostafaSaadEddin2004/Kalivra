import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kalivra/controller/prefs/local_store.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStore.getToken();
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    debugPrint('❌ Dio error: ${err.response?.statusCode} → ${err.message}');
    debugPrint('📨 Error body: $data');
    super.onError(err, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(
      '✅ Response [${response.statusCode}] → ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.enabled = true, this.logResponseBody = false});

  final bool enabled;
  final bool logResponseBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) {
      handler.next(options);
      return;
    }
    debugPrint('→ API ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) {
      handler.next(response);
      return;
    }
    final uri = response.requestOptions.uri.toString();
    debugPrint('← API $uri → ${response.statusCode}');
    if (logResponseBody && response.data != null) {
      debugPrint('  DATA: $uri');
      debugPrint('  ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint('✗ API ${err.requestOptions.uri} ${err.message}');
      if (err.response?.data != null) {
        debugPrint('  ERROR DATA: ${err.response!.data}');
      }
    }
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = err.response!.data['message'] ?? '';
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: message,
        response: err.response,
      ),
    );
  }
}
