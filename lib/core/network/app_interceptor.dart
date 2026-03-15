import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({this.getToken});

  final Future<String?> Function()? getToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    debugPrint('❌ Dio error: ${err.response?.statusCode} → ${err.message}');
    debugPrint('📨 Error body: $data');
    super.onError(err, handler);
  }
  
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
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
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!enabled) {
      handler.next(options);
      return;
    }
    debugPrint('→ API ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
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
    final apiException = _toApiException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        response: err.response,
      ),
    );
  }

  ApiException _toApiException(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    String message = err.message ?? 'Unknown error';
    Map<String, dynamic>? errors;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      if (data['errors'] != null) {
        errors = data['errors'] is Map
            ? Map<String, dynamic>.from(data['errors'] as Map)
            : null;
      }
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      errors: errors,
      response: err.response,
    );
  }
}

class ApiException implements Exception {
  const ApiException({
    this.statusCode,
    required this.message,
    this.errors,
    this.response,
  });

  final int? statusCode;
  final String message;
  final Map<String, dynamic>? errors;
  final Response<dynamic>? response;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
