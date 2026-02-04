import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String status;
  final String checkInTime;
  final String? checkOutTime;
  final double? distance;
  final String? date;
  final String? scheduledCheckInTime;
  final String? scheduledCheckOutTime;

  const Attendance({
    required this.status,
    required this.checkInTime,
    this.checkOutTime,
    this.distance,
    this.date,
    this.scheduledCheckInTime,
    this.scheduledCheckOutTime,
  });

  @override
  List<Object?> get props => [
        status,
        checkInTime,
        checkOutTime,
        distance,
        date,
        scheduledCheckInTime,
        scheduledCheckOutTime,
      ];
}

class AttendanceRecap extends Equatable {
  final int present;
  final int late;
  final int permission;
  final int leave;

  const AttendanceRecap({
    required this.present,
    required this.late,
    required this.permission,
    required this.leave,
  });

  @override
  List<Object?> get props => [present, late, permission, leave];
}
