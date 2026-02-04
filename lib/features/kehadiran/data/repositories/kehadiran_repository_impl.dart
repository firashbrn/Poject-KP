import '../../../../core/errors/exceptions.dart';
import '../../data/datasources/kehadiran_remote_datasource.dart';
import '../../domain/entities/kehadiran.dart';
import '../../domain/repositories/kehadiran_repository.dart';

class KehadiranRepositoryImpl implements KehadiranRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  KehadiranRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Attendance> checkIn(double lat, double long) async {
    try {
      return await remoteDataSource.checkIn(lat, long);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Attendance> checkOut(double lat, double long) async {
    try {
      return await remoteDataSource.checkOut(lat, long);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Attendance>> getHistory() async {
    try {
      return await remoteDataSource.getHistory();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AttendanceRecap> getRecap(String month, String year) async {
    try {
      return await remoteDataSource.getRecap(month, year);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getTodayStatus() async {
    try {
      return await remoteDataSource.getTodayStatus();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
