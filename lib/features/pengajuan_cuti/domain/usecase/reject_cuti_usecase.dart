import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/cuti_repository.dart';

class RejectCutiUseCase extends UseCase<void, RejectCutiParams> {
  final CutiRepository _repository;

  RejectCutiUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(RejectCutiParams? params) async {
    final controller = StreamController<void>();
    try {
      if (params == null) {
        controller.addError(Exception("Params cannot be null"));
        controller.close();
        return controller.stream;
      }

      // VALIDASI: Catatan Wajib Minimal 10 Karakter
      if (params.catatan.trim().length < 10) {
        throw Exception("Catatan penolakan wajib diisi minimal 10 karakter.");
      }

      await _repository.tolakCuti(params.cutiId, params.catatan);
      controller.add(null);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}

class RejectCutiParams {
  final int cutiId;
  final String catatan;

  RejectCutiParams({required this.cutiId, required this.catatan});
}
