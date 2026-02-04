import 'package:equatable/equatable.dart';

class Cuti extends Equatable {
  final int? id;
  final String? userId; // Untuk validasi role/unit
  final String? namaUser;
  final String? jenisCuti;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? alasan;
  final String? fileBukti;
  final String? status; // MENUNGGU, DISETUJUI, DITOLAK
  final String? catatanPenolakan; // Wajib jika DITOLAK
  final String? unitKerja;

  const Cuti({
    this.id,
    this.userId,
    this.namaUser,
    this.jenisCuti,
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
        jenisCuti,
        tanggalMulai,
        tanggalSelesai,
        alasan,
        fileBukti,
        status,
        catatanPenolakan,
        unitKerja,
      ];
}
