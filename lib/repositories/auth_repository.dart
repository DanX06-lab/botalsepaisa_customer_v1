import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../core/api/api_client.dart';
import '../core/api/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(apiClient, secureStorage);
});

abstract class AuthRepository {
  Future<UserModel> login(String phone, String password);
  Future<UserModel> register(String name, String phone, String email, String password);
  Future<void> logout();
  Future<UserModel?> getProfile();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._apiClient, this._storage);

  @override
  Future<UserModel> login(String phone, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'phone_number': phone,
          'password': password,
        },
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      
      return user;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['detail'] ?? 'Login failed');
      }
      throw Exception('Network error during login');
    }
  }

  @override
  Future<UserModel> register(String name, String phone, String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'full_name': name,
          'phone_number': phone,
          'email': email.isNotEmpty ? email : null,
          'password': password,
        },
      );
      
      // The register endpoint might not return a token. If it just returns user data,
      // the user will need to log in, OR the API might auto-login.
      // Based on typical flows, let's just return the created user and let the UI decide.
      final data = response.data['data'];
      final user = UserModel.fromJson(data);
      return user;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['detail'] ?? 'Registration failed');
      }
      throw Exception('Network error during registration');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (e) {
      // Ignore errors on logout (e.g. already logged out on server)
    } finally {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
    }
  }

  @override
  Future<UserModel?> getProfile() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) return null;

      final response = await _apiClient.get('/users/me'); // Assuming standard profile endpoint
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }
}
