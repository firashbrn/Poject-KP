import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/izin_repository.dart';

class RejectIzinUseCase extends UseCase<void, RejectIzinParams> {
  final IzinRepository _repository;

  RejectIzinUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(RejectIzinParams? params) async {
    final controller = StreamController<void>();
    try {
      if (params == null) {
        controller.addError(Exception("Params cannot be null"));
        controller.close();
        return controller.stream;
      }

      if (params.catatan.trim().length < 10) {
        throw Exception("Catatan penolakan wajib diisi minimal 10 karakter.");
      }

      await _repository.tolakIzin(params.izinId, params.catatan);
      controller.add(null);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}

class RejectIzinParams {
  final int izinId;
  final String catatan;

  RejectIzinParams({required this.izinId, required this.catatan});
}
