import '../entities/kehadiran.dart';

abstract class KehadiranRepository {
  Future<Attendance> checkIn(double lat, double long);
  Future<Attendance> checkOut(double lat, double long);
  Future<List<Attendance>> getHistory();
  Future<AttendanceRecap> getRecap(String month, String year);
  Future<Map<String, dynamic>> getTodayStatus();
}
