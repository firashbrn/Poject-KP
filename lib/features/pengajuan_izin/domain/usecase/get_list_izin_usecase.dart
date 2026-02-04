import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/izin_repository.dart';
import '../entities/izin.dart';

class GetListIzinUseCase extends UseCase<List<Izin>, void> {
  final IzinRepository _repository;

  GetListIzinUseCase(this._repository);

  @override
  Future<Stream<List<Izin>>> buildUseCaseStream(void params) async {
    final controller = StreamController<List<Izin>>();
    try {
      final list = await _repository.getRiwayatIzin();
      controller.add(list);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}
