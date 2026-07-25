import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthController extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    try {
      // Attempt to restore session by fetching the user profile
      // The API client will automatically attach the token and handle refresh if needed.
      final user = await authRepo.getProfile();
      return user;
    } catch (e) {
      // If fetching profile fails (e.g. token expired and refresh failed),
      // we are not logged in.
      return null;
    }
  }

  Future<void> login(String phone, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.login(phone, password);
      return user;
    });
  }

  Future<void> register(String name, String phone, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.register(name, phone, email, password);
      // Depending on backend, register might auto-login or we might need to manually login.
      // If backend returns a token, authRepo.register should save it. If not, this might need 
      // to chain a login call. Assuming auto-login or manual login follows if state stays null.
      // For now, if we get a user back, we can set it as state, but typically we want a fresh login.
      return user; 
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();
      return null;
    });
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(() {
      return AuthController();
    });
