
import '../entities/user.dart';

abstract class AuthRepository {
  
  Future<User> login({
     String nip,
     String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  });

  Future<String> requestOTP({
    required String nip,
  });

  Future<String> verifyOTP(
    String nip,
    String otp,
  );

  Future<String> resetPassword({required String nip, required String newPassword, required String otp});

  Future<bool> isAuthenticated();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

}