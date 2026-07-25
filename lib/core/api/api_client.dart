import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _storage.read(key: 'access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Attempt token refresh
          final refreshToken = await _storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            try {
              // Call refresh endpoint directly using a new Dio instance to avoid interceptor loop
              final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
              final response = await refreshDio.post(
                ApiConstants.refresh,
                data: {'refresh_token': refreshToken},
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['data']['access_token'];
                final newRefreshToken = response.data['data']['refresh_token'];
                
                await _storage.write(key: 'access_token', value: newAccessToken);
                await _storage.write(key: 'refresh_token', value: newRefreshToken);

                // Retry original request
                final retryOptions = Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                retryOptions.headers?['Authorization'] = 'Bearer $newAccessToken';

                final retryResponse = await _dio.request(
                  error.requestOptions.path,
                  options: retryOptions,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              // Refresh failed, user needs to login again.
              // This should trigger a logout cascade.
              await _storage.delete(key: 'access_token');
              await _storage.delete(key: 'refresh_token');
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
