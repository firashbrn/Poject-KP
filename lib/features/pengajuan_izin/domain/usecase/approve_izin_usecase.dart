import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../repositories/izin_repository.dart';

class ApproveIzinUseCase extends UseCase<void, int> {
  final IzinRepository _repository;

  ApproveIzinUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(int? izinId) async {
    final controller = StreamController<void>();
    try {
      if (izinId == null) throw Exception("ID required");
      await _repository.setujuiIzin(izinId);
      controller.add(null);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}
