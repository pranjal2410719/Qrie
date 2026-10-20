import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'rfc7807_error.dart';

/// Central API Client for Qrie Student App
class ApiClient {
  final Dio _dio;
  final SecureStorageService secureStorage;

  ApiClient({
    AppConfig? config,
    SecureStorageService? storage,
    void Function()? onSessionExpired,
  })  : secureStorage = storage ?? SecureStorageService(),
        _dio = Dio(
          BaseOptions(
            baseUrl: (config ?? AppConfig.current).apiBaseUrl,
            connectTimeout: (config ?? AppConfig.current).connectTimeout,
            receiveTimeout: (config ?? AppConfig.current).receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  Dio get rawDio => _dio;

  Future<dynamic> get(
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
      return response.data;
    } on DioException catch (e) {
      throw ProblemDetails.fromDioException(e);
    } catch (e) {
      throw ProblemDetails(
        title: 'Unexpected Error',
        status: 500,
        detail: e.toString(),
      );
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ProblemDetails.fromDioException(e);
    } catch (e) {
      throw ProblemDetails(
        title: 'Unexpected Error',
        status: 500,
        detail: e.toString(),
      );
    }
  }

  Future<dynamic> put(
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
      return response.data;
    } on DioException catch (e) {
      throw ProblemDetails.fromDioException(e);
    } catch (e) {
      throw ProblemDetails(
        title: 'Unexpected Error',
        status: 500,
        detail: e.toString(),
      );
    }
  }

  Future<dynamic> delete(
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
      return response.data;
    } on DioException catch (e) {
      throw ProblemDetails.fromDioException(e);
    } catch (e) {
      throw ProblemDetails(
        title: 'Unexpected Error',
        status: 500,
        detail: e.toString(),
      );
    }
  }
}
