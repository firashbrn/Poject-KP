import 'package:dio/dio.dart';
import 'package:presensi_application_1/core/utils/device_utils.dart';
import 'package:presensi_application_1/core/utils/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../../../../core/constants/api_constants.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({
    required String nip,
    required String password,
  });

  Future<void> changePassword(String oldPassword, String newPassword);
  Future<String> forgotPassword(String nip);
  Future<void> resetPassword(String newPassword);
  Future<String> verifyOTP(String nip, String otp);
  Future<UserModel> getProfile();
  Future<UserModel> refreshToken(String refreshToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});
  
  @override
  Future<UserModel> login({
    required String nip,
    required String password,
  }) async {
    try {
      final deviceInfo = await DeviceUtils.getDeviceInfo();
      
      final response = await apiClient.post(
        ApiConstants.Login,
        data: {
          'nip': nip,
          'password': password,
          'device_id': deviceInfo['uuid'], 
          'brand': deviceInfo['brand'],
          'series': deviceInfo['series'],
        },
      );
     if (response.statusCode == 200) {
        // Response format: {"message": "Login Berhasil", "token": "...", "refresh_token": "...", "data": {...}}
        final token = response.data['token'] as String? ?? '';
        final refreshToken = response.data['refresh_token'] as String? ?? '';
        final userData = response.data['data'] as Map<String, dynamic>? ?? {};

        return UserModel(
          id: token.isNotEmpty ? token : 'generated-id',
          nip: userData['nip'] ?? nip,
          name: userData['nama'] ?? userData['name'] ?? 'Pegawai',
          email: userData['email'],
          phone: userData['no_hp'] ?? userData['phone'],
          jabatan: userData['jabatan'],
          bidang: userData['bidang'],
          atasanId: (userData['atasan_id'] ?? userData['atasanId'])?.toString(),
          atasanNama: (userData['atasan_nama'] ?? userData['atasan_name'])
              ?.toString(),
          role: (userData['role'] ?? userData['Role'])?.toString(),
          token: token,
          refreshToken: refreshToken,
        );
      } else {
        throw ServerException(response.statusMessage ?? 'Server Error');
      }
    } on DioException catch (e) {
      // DEBUG LOGGING
      AppLogger('LOGIN DIO ERROR: ${e.type} - ${e.message}');

      String errorMessage = 'Terjadi kesalahan jaringan.';

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Koneksi timeout. Coba lagi.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Tidak ada koneksi internet.';
          break;
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          if (statusCode == 401) {
            errorMessage = 'NIP atau Kata Sandi salah. (401)';
          } else if (statusCode == 500) {
            errorMessage = 'Server Error. (500)';
          } else {
            errorMessage =
                'Masalah Server ($statusCode): ${e.response?.statusMessage ?? "Gagal memproses."}';
          }
          break;
        default:
          errorMessage = 'Kesalahan tidak diketahui (000)';
          break;
      }

      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await apiClient.put(
        ApiConstants.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        String msg = 'Gagal mengubah sandi';
        if (response.data is Map) {
          msg = response.data['message'] ?? msg;
        } else if (response.data is String) {
          msg = response.data;
        }
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      String msg = 'Gagal mengubah sandi';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          msg = e.response!.data['message'] ?? e.response!.data['error'] ?? msg;
        } else if (e.response!.data is String) {
          msg = e.response!.data;
        }
      }
      throw ServerException(msg);
    }catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }
  
  @override
  Future<String> forgotPassword(String nip) async {
    try{
      final response = await apiClient.post(
        ApiConstants.forgotPassword,
        data: {
          'nip': nip,
        },
      );
      if (response.statusCode == 200) {
        final message = response.data['message'] as String? ?? 'OTP Berhasil dikirim ke email.';
        return message;
      } else {
        throw ServerException('Gagal mengirim email lupa kata sandi.');
      }
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }

  }
  
  @override
  Future<UserModel> getProfile() async {
   try{
    final response = await apiClient.get(ApiConstants.getProfile);
    if (response.statusCode == 200) {
      final userData = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } else {
      throw ServerException(response.statusMessage ?? 'Gagal Memuat Profil');
    }
   }catch(e){
    throw ServerException('Terjadi kesalahan: ${e.toString()}');
  }
  }
  
  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.refreshToken,
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String? ?? '';
        final userData = response.data['data'] as Map<String, dynamic>? ?? {};

        return UserModel.fromJson({'userData' : userData, 'token': token});

      } else {
        throw ServerException(response.statusMessage ?? 'Gagal Memperbarui Token');
      }
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');

    }
  }
  
  @override
  Future<void> resetPassword(String newPassword)async {
   try{
    final response = await apiClient.post(
      ApiConstants.resetPassword,
      data: {
        'new_password': newPassword,
      },
    );
    if (response.statusCode != 200) {
        String msg = 'Gagal memperbaharui sandi';
        if (response.data is Map) {
          msg = response.data['message'] ?? msg;
        } else if (response.data is String) {
          msg = response.data;
        }
        throw ServerException(msg);
      }
    } on DioException catch (e) {
      String msg = 'Gagal memperbaharui sandi';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          msg = e.response!.data['message'] ?? e.response!.data['error'] ?? msg;
        } else if (e.response!.data is String) {
          msg = e.response!.data;
        }
      }
      throw ServerException(msg);
   } catch (e) {
     throw ServerException('Terjadi kesalahan: ${e.toString()}');
   }
  }
  
  @override
  Future<String> verifyOTP(String nip, String otp) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyOTP,
        data: {
          'nip': nip,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final message = response.data['message'] as String? ?? 'OTP Terverifikasi.';
        return message;
      } else {
        throw ServerException('Gagal memverifikasi OTP.');
      }

    }catch(e){
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }
  
}