import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/cuti_repository.dart';

class ApproveCutiUseCase extends UseCase<void, int> {
  final CutiRepository _repository;

  ApproveCutiUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(int? cutiId) async {
    final controller = StreamController<void>();
    try {
      if (cutiId == null) {
        throw Exception("Cuti ID required");
      }
      await _repository.setujuiCuti(cutiId);
      controller.add(null);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}
