import '../models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

abstract class AuthRepository {
  Future<UserModel> login(String phone, String password);
  Future<void> sendOtp(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<UserModel> register(String name, String phone, String email, String password);
}

class MockAuthRepository implements AuthRepository {
  final UserModel _mockUser = UserModel(
    id: 'user_123',
    name: 'John Doe',
    phone: '9876543210',
    email: 'john@example.com',
    referralCode: 'BOTAL50',
  );

  @override
  Future<UserModel> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (phone.isNotEmpty && password.isNotEmpty) {
      return _mockUser;
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp == '1234') {
      return _mockUser;
    }
    throw Exception('Invalid OTP');
  }

  @override
  Future<UserModel> register(String name, String phone, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return _mockUser;
  }
}
