import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final sp = await SharedPreferences.getInstance();
    final localeSP = sp.getString(PrefKeys.localeKey);
    final locale =
        (localeSP == null ||
            localeSP.isEmpty ||
            localeSP == PrefKeys.systemLocaleKey)
        ? PlatformDispatcher.instance.locale.languageCode ==
                  PrefKeys.arLocaleKey
              ? PrefKeys.arLocaleKey
              : PrefKeys.enLocaleKey
        : localeSP;

    final token = await LocalStore.getToken();
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Locale': locale,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }
}

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.enabled = true, this.logResponseBody = false});

  final bool enabled;
  final bool logResponseBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final message = data is Map ? data['message']?.toString() ?? '' : '';
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: message,
        response: err.response,
      ),
    );
  }
}
