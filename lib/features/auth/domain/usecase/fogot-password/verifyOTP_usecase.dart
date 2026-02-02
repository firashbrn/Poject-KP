import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../../core/utils/logger.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<String, VerifyOtpParams> {
  final AuthRepository _authRepository;

  VerifyOtpUseCase(this._authRepository);

  @override
  Future<Stream<String>> buildUseCaseStream(VerifyOtpParams? params) async {
    final StreamController<String> controller = 
    StreamController<String>();
    
    try {
      if (params == null || params.otp.isEmpty) {
        controller.addError(Exception('OTP must not be empty'));
        return controller.stream;
      }else {
      AppLogger('Attempting verify OTP for NIP: ${params.nip}');
  
      await _authRepository.verifyOTP(params.nip,params.otp  );
      AppLogger('OTP Berhasil diverifikasi');
      controller.add('Verifikasi OTP berhasil');
      }
      controller.close();
    } catch (e) {
      AppLogger('Verify OTP failed: $e');
      controller.addError(e);
      controller.close();

    }
    return controller.stream;
  }
}

class VerifyOtpParams {
  final String nip;
  final String otp;

  VerifyOtpParams(this.nip, this.otp);
}