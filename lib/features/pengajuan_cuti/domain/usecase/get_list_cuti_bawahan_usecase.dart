import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/cuti_repository.dart';
import '../entities/cuti.dart';

class GetListCutiBawahanUseCase extends UseCase<List<Cuti>, void> {
  final CutiRepository _repository;

  GetListCutiBawahanUseCase(this._repository);

  @override
  Future<Stream<List<Cuti>>> buildUseCaseStream(void params) async {
    final controller = StreamController<List<Cuti>>();
    try {
      final list = await _repository.getListPengajuanBawahan();
      controller.add(list);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}
