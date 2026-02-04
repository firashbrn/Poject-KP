import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../entities/kehadiran.dart';
import '../../repositories/kehadiran_repository.dart';


class CheckInUseCase extends UseCase<Attendance, CheckInParams> {
  final KehadiranRepository repository;

  CheckInUseCase(this.repository);

  @override
  Future<Stream<Attendance?>> buildUseCaseStream(CheckInParams? params) async {
    final controller = StreamController<Attendance?>();
    try {
      if (params == null) {
        controller.addError(Exception('Params must not be null'));
        controller.close();
        return controller.stream;
      }
      final attendance = await repository.checkIn(params.lat, params.long);
      controller.add(attendance);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}

class CheckInParams {
  final double lat;
  final double long;
  CheckInParams({required this.lat, required this.long});
}
