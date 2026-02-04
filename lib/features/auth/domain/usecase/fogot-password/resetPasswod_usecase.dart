import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../../core/utils/logger.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase extends UseCase<String, ResetPasswordParams>{
  final AuthRepository _authRepository;

  ResetPasswordUsecase(this._authRepository);

  @override
  Future<Stream<String>> buildUseCaseStream(ResetPasswordParams? params) async {
    final StreamController<String> controller = 
    StreamController<String>();
    
    try {
      if (params == null || params.newPassword.isEmpty) {
        controller.addError(Exception('Password baru tidak boleh kosong'));
      }else {
        AppLogger('Attempting to reset password for NIP: ${params.nip}');

      await _authRepository.resetPassword(
          nip : params.nip,
          newPassword: params.newPassword,
          otp: params.otp,
        );
        
        AppLogger('Password berhasil diperbaharui');
        controller.add('Password berhasil diperbaharui');
      }
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();

    }
    return controller.stream;
  }

}

  class ResetPasswordParams {
    final String nip;
    final String otp;
    final String newPassword;
    ResetPasswordParams(this.nip, this.newPassword, this.otp);
  }