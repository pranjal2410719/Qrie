import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

/// Injects Bearer token into outgoing HTTP requests and handles session invalidation.
class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required this.secureStorage,
    this.onSessionExpired,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['X-Client-App'] = 'Qrie-Student-Android';
    options.headers['X-Client-Version'] = '1.0.0';

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Clear expired credentials and notify session listener
      await secureStorage.clearSession();
      onSessionExpired?.call();
    }
    return handler.next(err);
  }
}
