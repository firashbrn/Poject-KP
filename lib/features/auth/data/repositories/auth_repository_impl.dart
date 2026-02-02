import 'package:presensi_application_1/core/utils/logger.dart';
import 'package:presensi_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:presensi_application_1/features/auth/data/datasources/auth_remote_datasource.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDataSource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> login({String nip = '', String password = ''}) async {
    try {
      final userModel = await remoteDatasource.login(nip: nip, password: password);
      await localDatasource.cacheUser(userModel);
      await localDatasource.cacheToken(
        userModel.token ?? userModel.id,
      ); // Use token if available, else id as fallback
      if (userModel.refreshToken != null) {
        await localDatasource.cacheRefreshToken(userModel.refreshToken!);
      }
      return userModel.toEntity();
    } catch (e) {
      AppLogger(
        'Login failed in repository',
      );
      rethrow;
    }
  }
  
  @override
  Future<void> changePassword({required String oldPassword, required String newPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
  
  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<bool> isAuthenticated() {
    // TODO: implement isAuthenticated
    throw UnimplementedError();
  }
  
  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
  
  @override
  Future<void> saveTokens({required String token, required String refreshToken}) {
    // TODO: implement saveTokens
    throw UnimplementedError();
  }
  
  @override
  Future<String> requestOTP({required String nip}) {
    // TODO: implement requestOTP
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOTP( String nip, String otp) async {

  throw UnimplementedError();
}
  @override
  Future<String> resetPassword({required String nip, required String newPassword}) async {

    throw UnimplementedError();
  }
}
