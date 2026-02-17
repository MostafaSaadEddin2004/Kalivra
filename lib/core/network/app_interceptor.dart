import 'package:dio/dio.dart';

/// Adds auth token to outgoing requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({this.getToken});

  /// Returns the current auth token (e.g. from secure storage).
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
}

/// Logs request/response and optionally errors.
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
    // ignore: avoid_print
    print('→ ${options.method} ${options.uri}');
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
    // ignore: avoid_print
    print('← ${response.statusCode} ${response.requestOptions.uri}');
    if (logResponseBody && response.data != null) {
      // ignore: avoid_print
      print(response.data);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      // ignore: avoid_print
      print('✗ ${err.requestOptions.uri} ${err.message}');
    }
    handler.next(err);
  }
}

/// Maps API error response (e.g. 4xx/5xx) to [ApiException].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _toApiException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        response: err.response,
        type: err.type,
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

/// Thrown when the API returns an error (4xx/5xx).
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
