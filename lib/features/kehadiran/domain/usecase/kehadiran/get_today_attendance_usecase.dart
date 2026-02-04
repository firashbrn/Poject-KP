import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../repositories/kehadiran_repository.dart';

class GetTodayAttendanceUseCase extends UseCase<Map<String, dynamic>, void> {
  final KehadiranRepository repository;

  GetTodayAttendanceUseCase(this.repository);

  @override
  Future<Stream<Map<String, dynamic>?>> buildUseCaseStream(void params) async {
    final controller = StreamController<Map<String, dynamic>?>();
    try {
      final status = await repository.getTodayStatus();
      controller.add(status);
      controller.close();
    } catch (e) {
      controller.addError(e);
      controller.close();
    }
    return controller.stream;
  }
}
