import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/izin_repository.dart';

class CreateIzinUseCase extends UseCase<void, CreateIzinParams> {
  final IzinRepository _repository;

  CreateIzinUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(CreateIzinParams? params) async {
    final controller = StreamController<void>();
    try {
      if (params == null) {
        throw Exception("Params required");
      }
      await _repository.mengajukanIzin(
        jenisIzin: params.jenisIzin,
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

class CreateIzinParams {
  final String jenisIzin;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String alasan;
  final String? fileBukti;

  CreateIzinParams({
    required this.jenisIzin,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alasan,
    this.fileBukti,
  });
}
