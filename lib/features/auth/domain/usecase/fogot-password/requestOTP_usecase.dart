import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../../core/utils/logger.dart';
import '../../repositories/auth_repository.dart';

class RequestotpUsecase extends UseCase<String, RequestOtpParams> {
  final AuthRepository _authRepository;

  RequestotpUsecase(this._authRepository);

  @override
  Future<Stream<String>> buildUseCaseStream(RequestOtpParams? params) async {
    final StreamController<String> controller = 
    StreamController<String>();
    
    try {
      if (params == null || params.nip.isEmpty) {
        controller.addError(Exception('NIP tidak boleh kosong'));
        controller.close();
        return controller.stream;
      }else {
      AppLogger('Attempting request OTP for NIP: ${params.nip}');
  
      await _authRepository.requestOTP(nip: params.nip);
      AppLogger('OTP Berhasil dikirim ke email');
      controller.add('OTP Berhasil dikirim ke email');
      controller.close();
      }
    } catch (e) {
      AppLogger('Request OTP failed: $e');
      controller.addError(e);
      controller.close();

    }
    return controller.stream;
  }
}

class RequestOtpParams {
  final String nip;

  RequestOtpParams(this.nip);
}