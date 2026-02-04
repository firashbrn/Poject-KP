import 'package:equatable/equatable.dart';

class Izin extends Equatable {
  final int? id;
  final String? userId;
  final String? namaUser;
  final String? jenisIzin; // SAKIT, KELUAR KOTA, TERLAMBAT, PULANG CEPAT, LAINNYA
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? alasan;
  final String? fileBukti;
  final String? status; // MENUNGGU, DISETUJUI, DITOLAK
  final String? catatanPenolakan;
  final String? unitKerja;

  const Izin({
    this.id,
    this.userId,
    this.namaUser,
    this.jenisIzin,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.alasan,
    this.fileBukti,
    this.status,
    this.catatanPenolakan,
    this.unitKerja,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        namaUser,
        jenisIzin,
        tanggalMulai,
        tanggalSelesai,
        alasan,
        fileBukti,
        status,
        catatanPenolakan,
        unitKerja,
      ];
}
