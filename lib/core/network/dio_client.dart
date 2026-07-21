import 'package:dio/dio.dart';
import 'package:kalivra/core/network/app_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String baseUrl = "https://test2.kalivra-world.com/api/";

class DioClient {
  DioClient({
    String baseUrl = baseUrl,
    Future<String?> Function()? getToken,
    bool enableLogging = true,
    bool logResponseBody = true,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
         ),
       ) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(
        enabled: enableLogging,
        logResponseBody: logResponseBody,
      ),
      ErrorInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }

  final Dio _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      if(e.response!.requestOptions.connectTimeout != null) {
        throw 'Connection timeout';
      }else{
        throw e.response!.data['message'] ?? 'Something wrong';
      }
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
     if(e.response!.requestOptions.connectTimeout != null) {
        throw 'Connection timeout';
      }else{
        throw e.response!.data['message'] ?? 'Something wrong';
      }
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
       if(e.response!.requestOptions.connectTimeout != null) {
        throw 'Connection timeout';
      }else{
        throw e.response!.data['message'] ?? 'Something wrong';
      }
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      if(e.response!.requestOptions.connectTimeout != null) {
        throw 'Connection timeout';
      }else{
        throw e.response!.data['message'] ?? 'Something wrong';
      }
    }
  }
}
