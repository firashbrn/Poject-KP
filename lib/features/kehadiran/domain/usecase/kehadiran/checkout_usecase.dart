import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../entities/kehadiran.dart';
import '../../repositories/kehadiran_repository.dart';


class CheckOutUseCase extends UseCase<Attendance, CheckOutParams> {
  final KehadiranRepository repository;

  CheckOutUseCase(this.repository);

  @override
  Future<Stream<Attendance?>> buildUseCaseStream(CheckOutParams? params) async {
    final controller = StreamController<Attendance?>();
    try {
      if (params == null) {
        controller.addError(Exception('Params must not be null'));
        controller.close();
        return controller.stream;
      }
      final attendance = await repository.checkOut(params.lat, params.long);
      controller.add(attendance);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}

class CheckOutParams {
  final double lat;
  final double long;
  CheckOutParams({required this.lat, required this.long});
}
