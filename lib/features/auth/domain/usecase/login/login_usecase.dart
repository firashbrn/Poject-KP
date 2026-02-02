import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:presensi_application_1/core/utils/logger.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import 'login_usecase_params.dart';


class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<Stream<User?>> buildUseCaseStream(LoginParams? params) async {
    final controller = StreamController<User?>();

    try {
      if (params == null || params.nip.isEmpty || params.password.isEmpty) {
        controller.addError(Exception('NIP and password must not be empty'));
        controller.close();
        return controller.stream;
      } else {
      AppLogger('Attempting login for NIP: ${params.nip}');
  
    final user = await _authRepository.login(nip: params.nip, password: params.password);
    controller.add(user);

    AppLogger('Login successful for user: ${user.name}');
    controller.close();
      }
  } catch (e) {
    AppLogger('Login failed: $e');
    controller.addError(e);
    controller.close();
  }
    return controller.stream;
  }
}