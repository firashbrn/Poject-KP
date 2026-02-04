import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/cuti_repository.dart';

class CreateCutiUseCase extends UseCase<void, CreateCutiParams> {
  final CutiRepository _repository;

  CreateCutiUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(CreateCutiParams? params) async {
    final controller = StreamController<void>();
    try {
      if (params == null) {
        controller.addError(Exception("Params cannot be null"));
        controller.close();
        return controller.stream;
      }

      await _repository.mengajukanCuti(
        jenisCuti: params.jenisCuti,
        tanggalMulai: params.tanggalMulai,
        tanggalSelesai: params.tanggalSelesai,
        alasan: params.alasan,
        fileBukti: params.fileBukti,
      );
      controller.add(null);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}

class CreateCutiParams {
  final String jenisCuti;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String alasan;
  final String? fileBukti;

  CreateCutiParams({
    required this.jenisCuti,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    this.fileBukti,
  });
}
