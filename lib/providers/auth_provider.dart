import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

class AuthController extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final storage = ref.watch(secureStorageProvider);
    try {
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        return UserModel(
          id: 'user_123',
          name: 'John Doe',
          phone: '9876543210',
          email: 'john@example.com',
          referralCode: 'BOTAL50',
        );
      }
    } catch (e) {
      // Ignore secure storage errors for mock
    }
    return null;
  }

  Future<void> login(String phone, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.login(phone, password);
      final storage = ref.read(secureStorageProvider);
      try {
        await storage.write(key: 'auth_token', value: 'mock_token_123');
      } catch (e) {
        // Ignore for mock
      }
      return user;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(secureStorageProvider);
      try {
        await storage.delete(key: 'auth_token');
      } catch (e) {
        // Ignore for mock
      }
      return null;
    });
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(() {
      return AuthController();
    });
