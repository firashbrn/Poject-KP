import '../../domain/entities/kehadiran.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.status,
    required super.checkInTime,
    super.checkOutTime,
    super.distance,
    super.date,
    super.scheduledCheckInTime,
    super.scheduledCheckOutTime,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      status: json['status'] ?? json['status_masuk'] ?? 'UNKNOWN',
      checkInTime:
          json['jam_masuk_real'] ?? json['waktu_masuk'] ?? json['time'] ?? '-',
      checkOutTime:
          json['jam_pulang_real'] ??
          json['waktu_pulang'] ??
          json['check_out_time'],
      distance: (json['jarak'] as num?)?.toDouble(),
      date: json['tanggal'],
      scheduledCheckInTime:
          json['jam_masuk'] ??
          json['jam_masuk_jadwal'] ??
          json['shift']?['jam_masuk'] ??
          json['jadwal']?['jam_masuk'],
      scheduledCheckOutTime:
          json['jam_pulang'] ??
          json['jam_pulang_jadwal'] ??
          json['shift']?['jam_pulang'] ??
          json['jadwal']?['jam_pulang'],
    );
  }
}

class AttendanceRecapModel extends AttendanceRecap {
  const AttendanceRecapModel({
    required super.present,
    required super.late,
    required super.permission,
    required super.leave,
  });

  factory AttendanceRecapModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecapModel(
      present: json['hadir'] ?? 0,
      late: json['terlambat'] ?? 0,
      permission: json['izin'] ?? 0,
      leave: json['cuti'] ?? 0,
    );
  }
}
